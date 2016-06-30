#=
    support for Julia's intrinsics/basics
       other than predicates, comparatives, prearithmetics
=#

function copy{P}(x::ArbArb{P})
   z = init(ArbArb{P})
   ccall(@libarb(arb_set), Void, (Ptr{ArbArb{P}}), Ptr{ArbArb{P}}), &z, &x)
   return z
end
deepcopy{P}(x::ArbArb{P}) = copy(x)

