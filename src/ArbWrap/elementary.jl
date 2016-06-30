
for (op,cfunc) in ((:exp,:arb_exp), (:expm1, :arb_expm1),
    (:log,:arb_log), (:log1p, :arb_log1p),
    (:sin, :arb_sin), (:sinpi, :arb_sinpi), (:cos, :arb_cos), (:cospi, :arb_cospi),
    (:tan, :arb_tan), (:cot, :arb_cot),
    (:sinh, :arb_sinh), (:cosh, :arb_cosh), (:tanh, :arb_tanh), (:coth, :arb_coth),
    (:asin, :arb_asin), (:acos, :arb_asin), (:atan, :arb_atan),
    (:asinh, :arb_asinh), (:acosh, :arb_asinh), (:atanh, :arb_atanh),
    (:sinc, :arb_sinc),
    (:gamma, :arb_gamma), (:lgamma, :arb_lgamma), (:zeta, :arb_zeta),
    (:digamma, :arb_digamma), (:rgamma, :arb_rgamma)
    )
  @eval begin
    function ($op){P}(x::ArbArb{P})
      z = init(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, P)
      return z
    end
  end
end


function logbase{P}(x::ArbArb{P}, base::Int)
    b = UInt(abs(base))
    z = init(ArbArb{P})
    ccall(@libarb(arb_log_base_ui), Void, (Ptr{ArbArb}, Ptr{ArbArb}, UInt, Int), &z, &x, b, P)
    return z
end

log2{P}(x::ArbArb{P}) = logbase(x, 2)
log10{P}(x::ArbArb{P}) = logbase(x, 10)


for (op,cfunc) in ((:sincos, :arb_sin_cos), (:sincospi, :arb_sin_cos_pi), (:sinhcosh, :arb_sinh_cosh))
  @eval begin
    function ($op){P}(x::ArbArb{P})
        sz = init(ArbArb{P})
        cz = init(ArbArb{P})
        ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Ptr{ArbArb}, Int), &sz, &cz, &x, P)
        return (sz, cz)
    end
  end
end


function atan2{P}(a::ArbArb{P}, b::ArbArb{P})
    z = init(ArbArb{P})
    ccall(@libarb(arb_atan2), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &a, &b, P)
    return z
end

for (op,cfunc) in ((:^,:arb_pow_ui), (:pow,:arb_pow_ui), (:root, :arb_root_ui))
  @eval begin
    function ($op){P}(x::ArbArb{P}, y::Int)
      yy = UInt(y)
      z = init(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, UInt, Int), &z, &x, &yy, P)
      return z
    end
  end
end


for (op,cfunc) in ((:^,:arb_pow), (:pow,:arb_pow))
  @eval begin
    function ($op){P}(x::ArbArb{P}, y::ArbArb{P})
      z = init(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, &y, P)
      return z
    end
  end
end

root{P}(x::ArbArb{P}, y::ArbArb{P}) = pow(x, inv(y))
