#=
   The mag type used by Arb (fredrikj.net/arb/mag.html)
   see also (https://github.com/thofma/Hecke.jl/blob/master/src/Misc/mag.jl)
=#

type ArbMag
    exponent::Int
    mantissa::UInt64
end

ArbMag{T<:Union{Int64,Int32}}(exponent::Int, mantissa::T) =
    ArbMag(exponent, mantissa % UInt64)

function releaseMag{T<:ArbMag}(x::T)
    ccall(@libarb(mag_clear), Void, (Ptr{T}, ), &x)
end

function init{T<:ArbMag}(::Type{T})
    z = ArbMag(zero(Int), zero(UInt64))
    ccall(@libarb(mag_init), Void, (Ptr{T}, ), &z)
    finalizer(z, releaseMag)
    z
end

ArbMag() = init(ArbMag)

# define hash so other things work
const hash_arbmag_lo = (UInt === UInt64) ? 0x29f934c433d9a758 : 0x2578e2ce
const hash_0_arbmag_lo = hash(zero(UInt), hash_arbmag_lo)
if UInt===UInt64
   hash(z::ArbMag, h::UInt) = hash( reinterpret(UInt64, z.exponent), z.mantissa )
else
   hash(z::ArbMag, h::UInt) = hash( reinterpret(UInt32, z.exponent) % UInt64, z.mantissa )
end

function convert{T<:ArbMag}(::Type{T}, x::Float64)
    z = ArbMag()
    ccall(@libarb(mag_set_d), Void, (Ptr{T}, Ptr{Float64}), &z, &x)
    z
end
function convert{T<:ArbMag}(::Type{T}, x::Float32)
    convert(T, convert(Float64, x))
end

function convert{T<:ArbMag}(::Type{T}, x::UInt)
    z = ArbMag()
    ccall(@libarb(mag_set_ui), Void, (Ptr{T}, Ptr{UInt}), &z, &x)
    z
end
function convert{T<:ArbMag}(::Type{T}, x::Int)
    if x < 0
        throw(ErrorException("Arb magnitudes must be nonnegative"))
    end
    convert(T, convert(UInt,x))
end

for T in (:UInt, :Int, :Float32, :Float64)
    @eval promote_rule(::Type{ArbMag}, ::Type{$T}) = ArbMag
end

