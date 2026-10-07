#!/usr/bin/env python3
"""Generate the tweakctl app icon (pure Python — no PIL/ImageMagick).

Design: rounded square, dark slate gradient, three mixer sliders
(the "tweak" glyph) with green knobs — the project's accent color.

Rendered at 4x and box-filtered down for anti-aliasing. Writes:
  tweakctl.png        256x256 RGBA (used by all packages + AppImage)
  tweakctl.svg        vector version (repo reference)

Usage: python3 make-logo.py [size]
"""
import math
import struct
import sys
import zlib

# palette
BG_TOP = (35, 39, 51)        # #232733 dark slate
BG_BOT = (20, 22, 30)        # #14161E
BAR = (215, 219, 228)        # #D7DBE4 light gray
KNOB = (46, 204, 113)        # #2ECC71 green accent
KNOB_DARK = (31, 148, 81)    # darker green for the knob ring

SS = 4                         # supersample factor
SIZE = int(sys.argv[1]) if len(sys.argv) > 1 else 256
W = H = SIZE * SS


def rounded_rect(buf, x0, y0, x1, y1, r, color):
    """Fill a rounded rect (x1/y1 exclusive) with a solid color."""
    for y in range(y0, y1):
        for x in range(x0, x1):
            # distance to the nearest point inside the rect core
            cx = min(max(x, x0 + r), x1 - r)
            cy = min(max(y, y0 + r), y1 - r)
            if (x - cx) ** 2 + (y - cy) ** 2 <= r * r:
                buf[y * W + x] = color


def gradient_rect(buf, x0, y0, x1, y1, r, ctop, cbot):
    for y in range(y0, y1):
        t = (y - y0) / max(1, (y1 - y0))
        col = tuple(int(ctop[i] + (cbot[i] - ctop[i]) * t) for i in range(3))
        for x in range(x0, x1):
            cx = min(max(x, x0 + r), x1 - r)
            cy = min(max(y, y0 + r), y1 - r)
            if (x - cx) ** 2 + (y - cy) ** 2 <= r * r:
                buf[y * W + x] = col + (255,)


def circle(buf, cx, cy, r, color):
    r2 = r * r
    for y in range(int(cy - r), int(cy + r) + 1):
        for x in range(int(cx - r), int(cx + r) + 1):
            if (x - cx) ** 2 + (y - cy) ** 2 <= r2:
                buf[y * W + x] = color


def bar(buf, x0, x1, y, thickness, color):
    """Horizontal rounded bar (slider track)."""
    r = thickness // 2
    rounded_rect(buf, x0, y - r, x1, y + r, r, color + (255,))


buf = [(0, 0, 0, 0)] * (W * H)

# background: rounded square with a vertical gradient
margin = int(0.04 * W)
gradient_rect(buf, margin, margin, W - margin, H - margin,
              int(0.22 * W), BG_TOP, BG_BOT)

# sliders glyph — three tracks with knobs at different positions
gx0, gx1 = int(0.26 * W), int(0.74 * W)
thickness = int(0.055 * W)
rows = [
    (0.30, 0.66),   # (track y, knob x) as fractions of the icon
    (0.50, 0.42),
    (0.70, 0.71),
]
for fy, fx in rows:
    y = int(fy * H)
    bar(buf, gx0, gx1, y, thickness, BAR)
    knob_r = int(0.085 * W)
    kx = int(fx * W)
    circle(buf, kx, y, knob_r, KNOB_DARK + (255,))
    circle(buf, kx, y, knob_r - int(0.018 * W), KNOB + (255,))

# downsample (box filter, premultiplied alpha) -> RGBA pixels
out = bytearray()
prev_row = bytearray(SIZE * 4)
for oy in range(SIZE):
    row = bytearray()
    for ox in range(SIZE):
        ar = ag = ab = aa = 0
        for sy in range(SS):
            for sx in range(SS):
                r, g, b, a = buf[(oy * SS + sy) * W + ox * SS + sx]
                ar += r * a
                ag += g * a
                ab += b * a
                aa += a
        n = SS * SS
        a = aa // n
        if a:
            row += bytes((ar // n // a if a else 0,
                          ag // n // a if a else 0,
                          ab // n // a if a else 0, a))
        else:
            row += bytes((0, 0, 0, 0))
    out += b"\x00" + row          # filter type 0 per scanline


def chunk(tag, data):
    c = struct.pack(">I", len(data)) + tag + data
    return c + struct.pack(">I", zlib.crc32(tag + data))


png = (b"\x89PNG\r\n\x1a\n"
       + chunk(b"IHDR", struct.pack(">IIBBBBB", SIZE, SIZE, 8, 6, 0, 0, 0))
       + chunk(b"IDAT", zlib.compress(bytes(out), 9))
       + chunk(b"IEND", b""))
with open("tweakctl.png", "wb") as f:
    f.write(png)

svg = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#232733"/>
      <stop offset="1" stop-color="#14161E"/>
    </linearGradient>
  </defs>
  <rect x="10" y="10" width="236" height="236" rx="56" fill="url(#bg)"/>
  <g stroke="#D7DBE4" stroke-width="14" stroke-linecap="round">
    <line x1="66" y1="77" x2="190" y2="77"/>
    <line x1="66" y1="128" x2="190" y2="128"/>
    <line x1="66" y1="179" x2="190" y2="179"/>
  </g>
  <g fill="#2ECC71" stroke="#1F9451" stroke-width="5">
    <circle cx="169" cy="77" r="22"/>
    <circle cx="108" cy="128" r="22"/>
    <circle cx="182" cy="179" r="22"/>
  </g>
</svg>
'''
with open("tweakctl.svg", "w") as f:
    f.write(svg)

print(f"wrote tweakctl.png ({SIZE}x{SIZE}) and tweakctl.svg")
