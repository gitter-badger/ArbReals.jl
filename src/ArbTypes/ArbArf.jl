#=
   The arg type used by Arb (fredrikj.net/arb/arf.html)
   see also (https://github.com/Nemocas/Nemo.jl/blob/master/src/arb/ArbTypes.jl)
   see also (https://github.com/thofma/Hecke.jl/blob/master/src/Misc/arf.jl)
=#

# parameter P is the precision in bits
type ArbArf{P}
    exponent::Int
    size::UInt64
    mantissa1::Int64
    mantissa2::Int64
end

precision{P}(::Type{ArbArf{P}}) = P
precision{P}(x::ArbArf{P}) = P


ArbArf{P}(::Type{Val{P}}, exponent::Int, size::Int64, mantissa1::Int64, mantissa2::Int64) =
    ArbArf{P}(exponent, size % UInt64, mantissa1, mantissa2)
ArbArf{P}(::Type{Val{P}}, exponent::Int, size::Int32, mantissa1::Int64, mantissa2::Int64) =
    ArbArf{P}(exponent, Int64(size) % UInt64, mantissa1, mantissa2)


function releaseArf{P}(x::ArbArf{P})
    ccall(@libarb(arf_clear), Void, (Ptr{ArbArf{P}}, ), &x)
    return nothing
end

function init{P}(::Type{ArbArf{P}})
    z = ArbArf{P}(zero(Int), zero(UInt64), zero(Int64), zero(Int64))
    ccall(@libarb(arf_init), Void, (Ptr{ArbArf{P}}, ), &z)
    finalizer(z, releaseArf)
    return z
end

ArbArf{P}(::Type{Val{P}}) = init(ArbArf{P})


# define hash so other things work
const hash_arbarf_lo = (UInt === UInt64) ? 0x37e642589da3416a : 0x5d46a6b4
const hash_0_arbarf_lo = hash(zero(UInt), hash_arbarf_lo)
hash{P}(z::ArbArf{P}, h::UInt) =
    hash(reinterpret(UInt,z.mantissa1)$z.exponent,
         (h $ hash(reinterpret(UInt,z.mantissa2)$(~reinterpret(UInt,P)), hash_arbarf_lo) $ hash_0_arbarf_lo))

# rounding codes
# see https://github.com/fredrik-johansson/arb/blob/master/arf.h
# and https://github.com/fredrik-johansson/arb/blob/master/fmpr.h
const ArfRoundDown = 0
const ArfRoundUp = 1
const ArfRoundFloor = 2
const ArfRoundCeil = 3
const ArfRoundNearest = 4

# conversions

function convert{P}(::Type{BigFloat}, x::ArbArf{P})
    z = zero(BigFloat)
    ccall(@libarb(arf_get_mpfr), Void, (Ptr{BigFloat}, Ptr{ArbArf{P}}), &z, &x)
    return z
end

function convert{P}(::Type{ArbArf{P}}, x::BigFloat)
    z = init(ArbArf{P})
    ccall(@libarb(arf_set_mpfr), Void, (Ptr{ArbArf{P}}, Ptr{BigFloat}), &z, &x)
    return z
end

convert{P}(::Type{ArbArf{P}}, x::BigInt) = convert(ArbArf, convert(BigFloat,x))
convert{P}(::Type{ArbArf{P}}, x::Rational{BigInt}) = convert(ArbArf, convert(BigFloat,x))

function convert{P}(::Type{ArbArf{P}}, x::Float64)
    z = init(ArbArf{P})
    ccall(@libarb(arf_set_d), Void, (Ptr{ArbArf{P}}, Float64), &z, x)
    return z
end
convert{P}(::Type{ArbArf{P}}, x::Float32) = convert(ArbArf{P}, convert(Float64,x))

function convert{P}(::Type{Float64}, x::ArbArf{P})
    z = ccall(@libarb(arf_get_d), Float64, (Ptr{ArbArf{P}}, ), &x)
    return z
end
convert{P}(::Type{Float32}, x::ArbArf{P}) = convert(Float32, convert(Float64, x))


function frexp{P}(x::ArbArf{P})
   mantissa = init(ArbArf{P})
   exponent = zero(Int64)
   ccall(@libarb(arf_frexp), Void, (Ptr{ArfFloat{P}}, Int64, Ptr{ArfFloat{P}}), &mantissa, exponent, &x)
   mantissa, exponent
end
