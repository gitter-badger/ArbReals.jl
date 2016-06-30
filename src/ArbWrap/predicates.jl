# one parameter predicates

#!!Check that the indirect approach is not needed!!
function isnan{P}(x::ArbArb{P})
    a = convert(ArbArf{P}, x)
    #=
    if 0 != ccall(@libarb(arf_is_special, Int, (Ptr{ArbArf},), &a)
        if 0 == ccall(@libarb(arf_is_inf, Int, (Ptr{ArbArf},), &a)
            !iszero(x)
        else
            false
        end
    else
       false
    end
    =#
    z = ccall(@libarb(arf_is_nan), Int, (Ptr{ArbArf},), &a)
    return z != 0
end

function isinf{P}(x::ArbArb{P})
    a = convert(ArbArf{P}, x)
    z = ccall(@libarb(arf_is_inf), Int, (Ptr{ArbArf},), &a)
    return z != 0
end

function isfinite{P}(x::ArbArb{P})
    z = ccall(@libarb(arb_is_finite), Int, (Ptr{ArbArb},), &x)
    return z != 0
end


"""true iff midpoint(x) and radius(x) are zero"""
function iszero{P}(x::ArbArb{P})
    z = ccall(@libarb(arb_is_zero), Int, (Ptr{ArbArb},), &x)
    return z != 0
end

iszero{T<:Real}(x::T) = (x == zero(T))

"""true iff midpoint(x) or radius(x) are not zero"""
function notzero{P}(x::ArbArb{P})
    z = ccall(@libarb(arb_is_zero), Int, (Ptr{ArbArb},), &x)
    return z == 0
end

notzero{T<:Real}(x::T) = (x != zero(T))

"""true iff zero is not within [upperbound(x), lowerbound(x)]"""
function nonzero{P}(x::ArbArb{P})
    z = ccall(@libarb(arb_is_nonzero), Int, (Ptr{ArbArb},), &x)
    return z != 0
end

nonzero{T<:Real}(x::T) = (x != zero(T))

"""true iff midpoint(x) is one and radius(x) is zero"""
function isone{P}(x::ArbArb{P})
    z = ccall(@libarb(arb_is_one), Int, (Ptr{ArbArb},), &x)
    return z != 0
end

isone{T<:Real}(x::T) = (x == one(T))

"""true iff midpoint(x) is not one or midpoint(x) is one and radius(x) is nonzero"""
function notone{P}(x::ArbArb{P})
    z = ccall(@libarb(arb_is_one), Int, (Ptr{ArbArb},), &x)
    return z == 0
end

notone{T<:Real}(x::T) = (x != one(T))

"""true iff radius is zero"""
function isexact{P}(x::ArbArb{P})
    z = ccall(@libarb(arb_is_exact), Int, (Ptr{ArbArb},), &x)
    return z != 0
end

isexact{T<:Integer}(x::T) = true

"""true iff radius is nonzero"""
function notexact{P}(x::ArbArb{P})
    z = ccall(@libarb(arb_is_exact), Int, (Ptr{ArbArb},), &x)
    return z == 0
end

notexact{T<:Integer}(x::T) = false

"""true iff midpoint(x) is an integer and radius(x) is zero"""
function isinteger{P}(x::ArbArb{P})
    z = ccall(@libarb(arb_is_int), Int, (Ptr{ArbArb},), &x)
    return z != 0
end

"""true iff midpoint(x) is not an integer or radius(x) is nonzero"""
function notinteger{P}(x::ArbArb{P})
    z = ccall(@libarb(arb_is_int), Int, (Ptr{ArbArb},), &x)
    return z == 0
end

"""true iff lowerbound(x) is positive"""
function ispositive{P}(x::ArbArb{P})
    z = ccall(@libarb(arb_is_positive), Int, (Ptr{ArbArb},), &x)
    return z != 0
end

"""true iff upperbound(x) is negative"""
function isnegative{P}(x::ArbArb{P})
    z = ccall(@libarb(arb_is_negative), Int, (Ptr{ArbArb},), &x)
    return z != 0
end

"""true iff upperbound(x) is zero or negative"""
function notpositive{P}(x::ArbArb{P})
    z = ccall(@libarb(arb_is_nonpositive), Int, (Ptr{ArbArb},), &x)
    return z != 0
end

"""true iff lowerbound(x) is zero or positive"""
function notnegative{P}(x::ArbArb{P})
    z = ccall(@libarb(arb_is_nonnegative), Int, (Ptr{ArbArb},), &x)
    return z != 0
end

# two parameter predicates

"""true iff midpoint(x)==midpoint(y) and radius(x)==radius(y)"""
function isequal{P}(x::ArbArb{P}, y::ArbArb{P})
    z = ccall(@libarb(arb_equal), Int, (Ptr{ArbArb}, Ptr{ArbArb}), &x, &y)
    return z != 0
end

"""true iff midpoint(x)!=midpoint(y) or radius(x)!=radius(y)"""
function notequal{P}(x::ArbArb{P}, y::ArbArb{P})
    z = ccall(@libarb(arb_equal), Int, (Ptr{ArbArb}, Ptr{ArbArb}), &x, &y)
    return z == 0
end

"""true iff x and y have a common point"""
function overlap{P}(x::ArbArb{P}, y::ArbArb{P})
    z = ccall(@libarb(arb_overlaps), Int, (Ptr{ArbArb}, Ptr{ArbArb}), &x, &y)
    return z != 0
end

"""true iff x and y have no common point"""
function donotoverlap{P}(x::ArbArb{P}, y::ArbArb{P})
    z = ccall(@libarb(arb_overlaps), Int, (Ptr{ArbArb}, Ptr{ArbArb}), &x, &y)
    return z == 0
end

"""true iff x spans (covers) all of y"""
function contains{P}(x::ArbArb{P}, y::ArbArb{P})
    z = ccall(@libarb(arb_contains), Int, (Ptr{ArbArb}, Ptr{ArbArb}), &x, &y)
    return z != 0
end

"""true iff y spans (covers) all of x"""
function iscontainedby{P}(x::ArbArb{P}, y::ArbArb{P})
    z = ccall(@libarb(arb_contains), Int, (Ptr{ArbArb}, Ptr{ArbArb}), &y, &x)
    return z != 0
end

"""true iff x does not span (cover) all of y"""
function doesnotcontain{P}(x::ArbArb{P}, y::ArbArb{P})
    z = ccall(@libarb(arb_contains), Int, (Ptr{ArbArb}, Ptr{ArbArb}), &x, &y)
    return z == 0
end

"""true iff y does not span (cover) all of x"""
function isnotcontainedby{P}(x::ArbArb{P}, y::ArbArb{P})
    z = ccall(@libarb(arb_contains), Int, (Ptr{ArbArb}, Ptr{ArbArb}), &y, &x)
    return z == 0
end
