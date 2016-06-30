module ArbReals

import Base: hash, convert, promote_rule,
    String, string, show, showcompact, showall,
    copy, deepcopy,
    precision, setprecision,
    isnan, isinf, isfinite, zero, one,
    isequal, isless, (==), (!=), (<), (<=), (>=), (>),
    abs, signbit, sign, copysign, flipsign,
    round, floor, ceil, trunc,
    (+), (-), (*), (/),
    lowerbound, upperbound

export stringcompact,
    bounds, midpoint, radius, midpoint_radius,
    string_midpoint, stringall, lowerbound, upperbound,
    two, three, four, # use like zero(ArbArb)
    isnan, isinf, isfinite,
    iszero, notzero, nonzero, isone, notone,
    isexact, notexact, isinteger, notinteger,
    ispositive, notpositive, isnegative, notnegative,
    notequal, overlap, donotoverlap,
    contains, doesnotcontain, iscontainedby, isnotcontainedby


include("NemoLibs.jl")  # ensure needed C libraries

include("ArbTypes/ArbMag.jl")
include("ArbTypes/ArbArf.jl")
include("ArbTypes/ArbArb.jl")

include("ArbWrap/support.jl")
include("ArbWrap/numsupport.jl")
include("ArbWrap/predicates.jl")

end # module ArbReals
