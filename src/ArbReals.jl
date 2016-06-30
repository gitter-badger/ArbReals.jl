module ArbReals

import Base: hash, convert, promote_rule, string, show,
    isnan, isinf, isfinite, zero, one,
    isequal, isless, (==), (!=), (<), (<=), (>=), (>),
    abs, signbit, sign, copysign, flipsign,
    (+), (-), (*), (/)

include("NemoLibs.jl")  # ensure needed C libraries

include("ArbTypes/ArbMag.jl")
include("ArbTypes/Arf.jl")
include("ArbTypes/Arb.jl")

end # module ArbReals
