module ArbReals

import Base: hash, convert, promote_rule,
    string, show, showcompact,
    precision, setprecision,
    isnan, isinf, isfinite, zero, one,
    isequal, isless, (==), (!=), (<), (<=), (>=), (>),
    abs, signbit, sign, copysign, flipsign,
    (+), (-), (*), (/)

export stringcompact

include("NemoLibs.jl")  # ensure needed C libraries

include("ArbTypes/ArbMag.jl")
include("ArbTypes/ArbArf.jl")
include("ArbTypes/Arb.jl")

end # module ArbReals
