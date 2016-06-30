# adapted from Nemo
function (>){P}(x::ArbArb{P}, y::ArbArb{P})
    return Bool(ccall(@libarb(arb_gt), Cint, (Ptr{ArbArb{P}}, Ptr{ArbArb{P}}), &x, &y))
end
function (>=){P}(x::ArbArb{P}, y::ArbArb{P})
    return Bool(ccall(@libarb(arb_ge), Cint, (Ptr{ArbArb{P}}, Ptr{ArbArb{P}}), &x, &y))
end
function (<){P}(x::ArbArb{P}, y::ArbArb{P})
    return Bool(ccall(@libarb(arb_lt), Cint, (Ptr{ArbArb{P}}, Ptr{ArbArb{P}}), &x, &y))
end
function (<=){P}(x::ArbArb{P}, y::ArbArb{P})
    return Bool(ccall(@libarb(libarb), Cint, (Ptr{ArbArb{P}}, Ptr{ArbArb{P}}), &x, &y))
end

for F in (:(==), :(!=), :(<), :(<=), :(>=), :(>), :(isless), :(isequal))
  @eval ($F){P,Q}(x::ArbArb{P}, y::ArbArb{Q}) = ($F)(promote(x,y)...)
end

(==){R<:Real,P}(x::ArbArb{P}, y::R) = x == ArbArb{P}(y)
(!=){R<:Real,P}(x::ArbArb{P}, y::R) = x != ArbArb{P}(y)
(<=){R<:Real,P}(x::ArbArb{P}, y::R) = x <= ArbArb{P}(y)
(>=){R<:Real,P}(x::ArbArb{P}, y::R) = x >= ArbArb{P}(y)
(<){R<:Real,P}(x::ArbArb{P}, y::R) = x < ArbArb{P}(y)
(>){R<:Real,P}(x::ArbArb{P}, y::R) = x > ArbArb{P}(y)

(==){R<:Real,P}(x::R, y::ArbArb{P}) = ArbArb{P}(x) == y
(!=){R<:Real,P}(x::R, y::ArbArb{P}) = ArbArb{P}(x) != y
(<=){R<:Real,P}(x::R, y::ArbArb{P}) = ArbArb{P}(x) <= y
(>=){R<:Real,P}(x::R, y::ArbArb{P}) = ArbArb{P}(x) >= y
(<){R<:Real,P}(x::R, y::ArbArb{P}) = ArbArb{P}(x) < y
(>){R<:Real,P}(x::R, y::ArbArb{P}) = ArbArb{P}(x) > y

# see predicates.jl for isequal{P}(x::ArbArb{P}, y::ArbArb{P})
isless{P}(x::ArbArb{P}, y::ArbArb{P}) = (x<y)
