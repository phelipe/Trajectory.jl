using Trajectory
using Test

x0 = 0.
v0 = 0.
a0 = 0.
t0 = 0.
xf = 10.
vf = 0.
af = 0.
tf = 0.5

@test prod([0.0, 0.0, 0.0, 800.0, -2400.0, 1920.0] .≈ minimumjerk(x0, v0, a0, t0, xf, vf, af, tf))
x, v, a = map(x->x(tf), minimumjerkf(x0, v0, a0, t0, xf, vf, af, tf))
@test xf ≈ round(x)
@test vf ≈ round(v)
@test af ≈ round(a)