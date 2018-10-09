using Documenter, Trajectory

makedocs(
    modules = [Trajectory],
    format = :html,
    sitename = "Trajectory.jl",
    pages = Any["index.md"]
)

deploydocs(
    repo = "github.com/phelipe/Trajectory.jl.git",
    target = "build",
    julia = "1.0",
    deps = nothing,
    make = nothing,
)
