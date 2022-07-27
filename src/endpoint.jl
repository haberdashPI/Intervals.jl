struct Direction{T} end

const Left = Direction{:Left}()
const Right = Direction{:Right}()

const Beginning = Left
const Ending = Right

abstract type AbstractEndpoint end
struct Endpoint{T, D, B <: Bound} <: AbstractEndpoint
    endpoint::T

    function Endpoint{T,D,B}(ep::T) where {T, D, B <: Bounded}
        @assert D isa Direction
        new{T,D,B}(ep)
    end

    function Endpoint{T,D,B}(ep::Nothing) where {T, D, B <: Unbounded}
        @assert D isa Direction
        new{T,D,B}()
    end

    function Endpoint{T,D,B}(ep::Nothing) where {T, D, B <: Bounded}
        throw(MethodError(Endpoint{T,D,B}, (ep,)))
    end
end

Endpoint{T,D,B}(ep) where {T, D, B <: Bounded} = Endpoint{T,D,B}(convert(T, ep))

const LowerBound{T,B} = Endpoint{T, Left, B} where {T,B <: Bound}
const UpperBound{T,B} = Endpoint{T, Right, B} where {T,B <: Bound}

LowerBound{B}(ep::T) where {T,B} = LowerBound{T,B}(ep)
UpperBound{B}(ep::T) where {T,B} = UpperBound{T,B}(ep)

LowerBound(i::AbstractInterval{T,L,R}) where {T,L,R} = LowerBound{T,L}(L !== Unbounded ? first(i) : nothing)
UpperBound(i::AbstractInterval{T,L,R}) where {T,L,R} = UpperBound{T,R}(R !== Unbounded ? last(i) : nothing)

endpoint(x::Endpoint) = isbounded(x) ? x.endpoint : nothing
bound_type(x::Endpoint{T,D,B}) where {T,D,B} = B

isclosed(x::Endpoint) = bound_type(x) === Closed
isunbounded(x::Endpoint) = bound_type(x) === Unbounded
isbounded(x::Endpoint) = bound_type(x) !== Unbounded

function Base.hash(x::Endpoint{T,D,B}, h::UInt) where {T,D,B}
    h = hash(:Endpoint, h)
    h = hash(D, h)
    h = hash(B, h)

    # Bounded endpoints can skip hashing `T` as this is handled by hashing the endpoint
    # value field. Unbounded endpoints however, should ignore the stored garbage value and
    # should hash `T`.`
    h = B !== Unbounded ? hash(x.endpoint, h) : hash(T, h)

    return h
end

Base.broadcastable(e::Endpoint) = Ref(e)

"""
    ==(a::Endpoint, b::Endpoint) -> Bool

Determine if two endpoints are equal. When both endpoints are left or right then the points
and inclusiveness must be the same.

Checking the equality of left-endpoint and a right-endpoint is slightly more difficult. A
left-endpoint and a right-endpoint are only equal when they use the same point and are
both included. Note that left/right endpoints which are both not included are not equal
as the left-endpoint contains values below that point while the right-endpoint only contains
values that are above that point.

Visualizing two contiguous intervals can assist in understanding this logic:

    [x..y][y..z] -> UpperBound == LowerBound
    [x..y)[y..z] -> UpperBound != LowerBound
    [x..y](y..z] -> UpperBound != LowerBound
    [x..y)(y..z] -> UpperBound != LowerBound
"""
function Base.:(==)(a::Endpoint, b::Endpoint)
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

function Base.isequal(a::Endpoint, b::Endpoint)
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

# Comparisons between Scalars and Endpoints
Base.:(==)(a, b::Endpoint) = a == b.endpoint && isclosed(b)
Base.:(==)(a::Endpoint, b) = b == a

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
