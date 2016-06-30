module ArbReals

import Base: hash, convert, promote_rule,
    String, string, show, showcompact,
    precision, setprecision,
    isnan, isinf, isfinite, zero, one,
    isequal, isless, (==), (!=), (<), (<=), (>=), (>),
    abs, signbit, sign, copysign, flipsign,
    (+), (-), (*), (/),
    lowerbound, upperbound

export stringcompact,
    bounds, midpoint, radius, midpoint_radius

include("NemoLibs.jl")  # ensure needed C libraries

include("ArbTypes/ArbMag.jl")
include("ArbTypes/ArbArf.jl")
include("ArbTypes/ArbArb.jl")

end # module ArbReals
