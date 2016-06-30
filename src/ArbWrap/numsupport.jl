#=
    support for Julia's numeric intrinsics/basics
       other than arithmetic and higher functions
=#

for (op, i) in ((:zero,:0), (:one,:1), (:two,:2), (:three,:3), (:four, :4))
  @eval begin
    function ($op){P}(::Type{ArbArb{P}})
        z = init(ArbArb{P})
        ccall(@libarb(arb_set_si), Void, (Ptr{ArbArb}, Int), &z, $i)
        z
    end
    ($op)(::Type{ArbArb}) = ($op)(ArbArb{precision(ArbArb)})
  end
end


signbit{P}(x::ArbArb{P}) =
    (0 != ccall(@libarb(arb_is_negative), Int, (Ptr{ArbArb},), &x))

for (op,cfunc) in ((:-,:arb_neg), (:abs, :arb_abs), (:sign, :arb_sgn))
  @eval begin
    function ($op){P}(x::ArbArb{P})
      z = init(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbFArb}), &z, &x)
      return z
    end
  end
end

# !!Check this!! these all use RoundNearest?

function round{P}(x::ArbArb{P}, sig::Int=P, base::Int=10)
    sig=abs(sig); base=abs(base)
    sigbits = min(P, ceil(Int, (sig * log(base)/log(2.0))))
    z = init(ArbArb{P})
    ccall(@libarb(arb_set_round), Void,  (Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, sigbits)
    return z
end

function ceil{P}(x::ArbArb{P}, sig::Int=P, base::Int=10)
    sig=abs(sig); base=abs(base)
    sigbits = min(P, ceil(Int, (sig * log(base)/log(2.0))))
    z = init(ArbArb{P})
    ccall(@libarb(arb_ceil), Void,  (Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, sigbits)
    return z
end

function floor{P}(x::ArbArb{P}, sig::Int=P, base::Int=10)
    sig=abs(sig); base=abs(base)
    sigbits = min(P, ceil(Int, (sig * log(base)/log(2.0))))
    z = init(ArbArb{P})
    ccall(@libarb(arb_floor), Void,  (Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, sigbits)
    return z
end


function trunc{P}(x::ArbArb{P}, sig::Int=P, base::Int=10)
    sig=abs(sig); base=abs(base)
    sigbits = min(P, ceil(Int, (sig * log(base)/log(2.0))))
    z = init(ArbArb{P})
    y = abs(x)
    ccall(@libarb(arb_floor), Void,  (Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &y, sigbits)
    return signbit(x) ? -z : z
end

function round{T,P}(::Type{T}, x::ArbArb{P}, sig::Int=P, base::Int=10)
    z = round(x, sig, base)
    return convert(T, z)
end
function ceil{T,P}(::Type{T}, x::ArbArb{P}, sig::Int=P, base::Int=10)
    z = ceil(x, sig, base)
    return convert(T, z)
end
function floor{T,P}(::Type{T}, x::ArbArb{P}, sig::Int=P, base::Int=10)
    z = floor(x, sig, base)
    return convert(T, z)
end
function trunc{T,P}(::Type{T}, x::ArbArb{P}, sig::Int=P, base::Int=10)
    z = trunc(x, sig, base)
    return convert(T, z)
end
