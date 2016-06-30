for (op,cfunc) in ((:factorial,:arb_fac_ui), (:doublefactorial,:arb_doublefac_ui))
  @eval begin
    function ($op){P}(x::ArbArb{P})
      signbit(x) && ErrorException("Domain Error: argument is negative")
      y = trunc(UInt, x)
      z = initializer(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, UInt, Int), &z, y, P)
      return z
    end
  end
end

function doublefactorial{R<:Real}(xx::R)
   P = precision(ArbArb)
   x = convert(ArbArb{P},xx)
   return doublefactorial(x)
end

for (op,cfunc) in ((:risingfactorial,:arb_rising),)
  @eval begin
    function ($op){P}(x::ArbArb{P}, y::ArbArb{P})
      signbit(x) && ErrorException("Domain Error: argument is negative")
      z = initializer(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, &y, P)
      return z
    end
    function ($op){R<:Real,P}(xx::R, y::ArbArb{P}, prec::Int=P)
      x = convert(ArbArb{P},xx)
      z = initializer(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, &y, P)
      return z
    end
    function ($op){R<:Real,P}(x::ArbArb{P}, yy::R, prec::Int=P)
      y = convert(ArbArb{P},yy)
      z = initializer(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, &y, P)
      return z
    end
    function ($op){R1<:Real,R2<:Real}(xx::R1, yy::R2)
      P = precision(ArbArb)
      x = convert(ArbArb{P},xx)
      y = convert(ArbArb{P},yy)
      z = initializer(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, &y, P)
      return z
    end
  end
end

for (op,cfunc) in ((:agm, :arb_agm), (:polylog, :arb_polylog))
  @eval begin
    function ($op){P}(x::ArbArb{P}, y::ArbArb{P}, prec::Int=P)
      z = initializer(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, &y, P)
      return z
    end
    function ($op){R<:Real,P}(xx::R, y::ArbArb{P}, prec::Int=P)
      x = convert(ArbArb{P},xx)
      z = initializer(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, &y, P)
      return z
    end
    function ($op){R<:Real,P}(x::ArbArb{P}, yy::R, prec::Int=P)
      y = convert(ArbArb{P},yy)
      z = initializer(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, &y, P)
      return z
    end
    function ($op){R1<:Real,R2<:Real}(xx::R1, yy::R2)
      P = precision(ArbArb)
      x = convert(ArbArb{P},xx)
      y = convert(ArbArb{P},yy)
      z = initializer(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, &y, P)
      return z
    end
  end
end
