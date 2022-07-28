# These `deserialize` methods are used to be able to deserialize intervals using the
# structure that was used before Intervals 1.3.

function Serialization.deserialize(s::AbstractSerializer, ::Type{Interval{T}}) where T
    lower = deserialize(s)
    upper = deserialize(s)
    inclusivity = deserialize(s)

    L = bound_type(lowerbound(inclusivity))
    U = bound_type(upperbound(inclusivity))

    return Interval{T,L,U}(lower, upper)
end

function Serialization.deserialize(s::AbstractSerializer, ::Type{AnchoredInterval{P,T}}) where {P,T}
    anchor = deserialize(s)
    inclusivity = deserialize(s)

    L = bound_type(lowerbound(inclusivity))
    U = bound_type(upperbound(inclusivity))

    return AnchoredInterval{P,T,L,U}(anchor)
end
