for (op,cfunc) in ((:inv, :arb_inv), (:sqrt, :arb_sqrt), (:invsqrt, :arb_rsqrt))
  @eval begin
    function ($op){P}(x::ArbArb{P})
      z = init(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, P)
      return z
    end
  end
end

for (op,cfunc) in ((:+,:arb_add), (:-, :arb_sub), (:*, :arb_mul), (:/, :arb_div), (:hypot, :arb_hypot))
  @eval begin
    function ($op){P}(x::ArbArb{P}, y::ArbArb{P})
      z = init(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &x, &y, P)
      return z
    end
    ($op){P,Q}(x::ArbArb{P}, y::ArbArb{Q}) = ($op)(promote(x,y)...)
    ($op){T<:AbstractFloat,P}(x::ArbArb{P}, y::T) = ($op)(x, convert(ArbArb{P}, y))
    ($op){T<:AbstractFloat,P}(x::T, y::ArbArb{P}) = ($op)(convert(ArbArb{P}, x), y)
  end
end

for (op,cfunc) in ((:+,:arb_add_si), (:-, :arb_sub_si), (:*, :arb_mul_si), (:/, :arb_div_si))
  @eval begin
    function ($op){P}(x::ArbArb{P}, y::Int)
      z = init(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Int, Int), &z, &x, y, P)
      return z
    end
  end
end

(+){P}(x::Int, y::ArbArb{P}) = (+)(y,x)
(-){P}(x::Int, y::ArbArb{P}) = -((-)(y,x))
(*){P}(x::Int, y::ArbArb{P}) = (*)(y,x)
(/){P}(x::Int, y::ArbArb{P}) = (/)(ArbArb{P}(x),y)

(+){P}(x::ArbArb{P}, y::Integer) = (+)(x, convert(ArbArb{P}, y))
(-){P}(x::ArbArb{P}, y::Integer) = (-)(x, convert(ArbArb{P}, y))
(*){P}(x::ArbArb{P}, y::Integer) = (*)(x, convert(ArbArb{P}, y))
(/){P}(x::ArbArb{P}, y::Integer) = (/)(x, convert(ArbArb{P}, y))

(+){P}(x::Integer, y::ArbArb{P}) = (+)(convert(ArbArb{P}, x), y)
(-){P}(x::Integer, y::ArbArb{P}) = -((-)(y, convert(ArbArb{P}, x)))
(*){P}(x::Integer, y::ArbArb{P}) = (*)(convert(ArbArb{P},x), y)
(/){P}(x::Integer, y::ArbArb{P}) = (/)(convert(ArbArb{P},x), y)

for (op,cfunc) in ((:addmul,:arb_addmul), (:submul, :arb_submul))
  @eval begin
    function ($op){P}(w::ArbArb{P}, x::ArbArb{P}, y::ArbArb{P})
      z = init(ArbArb{P})
      ccall(@libarb($cfunc), Void, (Ptr{ArbArb}, Ptr{ArbArb}, Ptr{ArbArb}, Ptr{ArbArb}, Int), &z, &w, &x, &y, P)
      return z
    end
  end
end

muladd{P}(a::ArbArb{P}, b::ArbArb{P}, c::ArbArb{P}) = addmul(c,a,b)
mulsub{P}(a::ArbArb{P}, b::ArbArb{P}, c::ArbArb{P}) = addmul(-c,a,b)
