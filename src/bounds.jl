struct Side{T} end

const Lower = Side{:Lower}()
const Upper = Side{:Upper}()

const Beginning = Lower
const Ending = Upper

abstract type AbstractBound end
struct Bound{T, D, B <: Boundedness} <: AbstractBound
    endpoint::T

    function Bound{T,D,B}(ep::T) where {T, D, B <: Bounded}
        @assert D isa Side
        new{T,D,B}(ep)
    end

    function Bound{T,D,B}(ep::Nothing) where {T, D, B <: Unbounded}
        @assert D isa Side
        new{T,D,B}()
    end

    function Bound{T,D,B}(ep::Nothing) where {T, D, B <: Bounded}
        throw(MethodError(Bound{T,D,B}, (ep,)))
    end
end

Bound{T,D,B}(ep) where {T, D, B <: Bounded} = Bound{T,D,B}(convert(T, ep))

const LowerBound{T,B} = Bound{T, Lower, B} where {T,B <: Boundedness}
const UpperBound{T,B} = Bound{T, Upper, B} where {T,B <: Boundedness}

LowerBound{B}(ep::T) where {T,B} = LowerBound{T,B}(ep)
UpperBound{B}(ep::T) where {T,B} = UpperBound{T,B}(ep)

LowerBound(i::AbstractInterval{T,L,U}) where {T,L,U} = LowerBound{T,L}(L !== Unbounded ? lowerbound(i) : nothing)
UpperBound(i::AbstractInterval{T,L,U}) where {T,L,U} = UpperBound{T,U}(U !== Unbounded ? upperbound(i) : nothing)

endpoint(x::Bound) = isbounded(x) ? x.endpoint : nothing
bound_type(x::Bound{T,D,B}) where {T,D,B} = B

isclosed(x::Bound) = bound_type(x) === Closed
isunbounded(x::Bound) = bound_type(x) === Unbounded
isbounded(x::Bound) = bound_type(x) !== Unbounded

function Base.hash(x::Bound{T,D,B}, h::UInt) where {T,D,B}
    h = hash(:Bound, h)
    h = hash(D, h)
    h = hash(B, h)

    # Bounded endpoints can skip hashing `T` as this is handled by hashing the endpoint
    # value field. Unbounded endpoints however, should ignore the stored garbage value and
    # should hash `T`.`
    h = B !== Unbounded ? hash(x.endpoint, h) : hash(T, h)

    return h
end

Base.broadcastable(e::Bound) = Ref(e)

"""
    ==(a::Bound, b::Bound) -> Bool

Determine if two endpoints are equal. When both endpoints are lower or upper then the points
and inclusiveness must be the same.

Checking the equality of lower-endpoint and a upper-endpoint is slightly more difficult. A
lower-endpoint and a upper-endpoint are only equal when they use the same point and are
both included. Note that lower/upper endpoints which are both not included are not equal
as the lower-endpoint contains values below that point while the upper-endpoint only contains
values that are above that point.

Visualizing two contiguous intervals can assist in understanding this logic:

    [x..y][y..z] -> UpperBound == LowerBound
    [x..y)[y..z] -> UpperBound != LowerBound
    [x..y](y..z] -> UpperBound != LowerBound
    [x..y)(y..z] -> UpperBound != LowerBound
"""
function Base.:(==)(a::Bound, b::Bound)
    return (
        isunbounded(a) && isunbounded(b) ||
        a.endpoint == b.endpoint && bound_type(a) == bound_type(b)
    )
end

function Base.:(==)(a::LowerBound, b::UpperBound)
    a.endpoint == b.endpoint && isclosed(a) && isclosed(b)
end

function Base.:(==)(a::UpperBound, b::LowerBound)
    b == a
end

function Base.isequal(a::Bound, b::Bound)
    return (
        isunbounded(a) && isunbounded(b) ||
        isequal(a.endpoint, b.endpoint) && isequal(bound_type(a), bound_type(b))
    )
end

function Base.isequal(a::LowerBound, b::UpperBound)
    isequal(a.endpoint, b.endpoint) && isclosed(a) && isclosed(b)
end

function Base.isequal(a::UpperBound, b::LowerBound)
    isequal(b, a)
end

function Base.isless(a::LowerBound, b::LowerBound)
    return (
        !isunbounded(b) && (
            isunbounded(a) ||
            a.endpoint < b.endpoint ||
            a.endpoint == b.endpoint && isclosed(a) && !isclosed(b)
        )
    )
end

function Base.isless(a::UpperBound, b::UpperBound)
    return (
        !isunbounded(a) && (
            isunbounded(b) ||
            a.endpoint < b.endpoint ||
            a.endpoint == b.endpoint && !isclosed(a) && isclosed(b)
        )
    )
end

function Base.isless(a::LowerBound, b::UpperBound)
    return (
        isunbounded(a) ||
        isunbounded(b) ||
        a.endpoint < b.endpoint
    )
end

function Base.isless(a::UpperBound, b::LowerBound)
    return (
        !isunbounded(a) && !isunbounded(b) &&
        (
            a.endpoint < b.endpoint ||
            a.endpoint == b.endpoint && !(isclosed(a) && isclosed(b))
        )
    )
end

# Comparisons between Scalars and Bounds
Base.:(==)(a, b::Bound) = a == b.endpoint && isclosed(b)
Base.:(==)(a::Bound, b) = b == a

function Base.isless(a, b::LowerBound)
    return (
        !isunbounded(b) && (
            a < b.endpoint ||
            a == b.endpoint && !isclosed(b)
        )
    )
end

function Base.isless(a::UpperBound, b)
    return (
        !isunbounded(a) &&
        (
            a.endpoint < b ||
            a.endpoint == b && !isclosed(a)
        )
    )
end

Base.isless(a, b::UpperBound) = isunbounded(b) || a < b.endpoint
Base.isless(a::LowerBound, b)  = isunbounded(a) || a.endpoint < b
