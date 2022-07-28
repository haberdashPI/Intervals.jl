"""
    Inclusivity(lowerbound::Bool, upperbound::Bool) -> Inclusivity

Defines whether an `AbstractInterval` is open, half-open, or closed.
"""

struct Inclusivity
    lowerbound::Bool
    upperbound::Bool

    function Inclusivity(lowerbound::Bool, upperbound::Bool; ignore_depwarn::Bool=false)
        if !ignore_depwarn
            depwarn(
                "`Inclusivity(::Bool, ::Bool)` is deprecated and has no direct replacement. " *
                "See `Interval` or `AnchoredInterval` constructors for alternatives.",
                :Inclusivity,
            )
        end
        return new(lowerbound, upperbound)
    end
end

"""
    Inclusivity(i::Integer) -> Inclusivity

Defines whether an interval is open, half-open, or closed, using an integer code:

### Inclusivity Values

* `0`: Neither endpoint is included (the `AbstractInterval` is open)
* `1`: Only the lesser endpoint is included (the `AbstractInterval` is lower-closed)
* `2`: Only the greater endpoint is included (the `AbstractInterval` is upper-closed)
* `3`: Both endpoints are included (the `AbstractInterval` is closed)

Note that this constructor does not perform bounds-checking: instead it checks the values
of the two least-significant bits of the integer. This means that `Inclusivity(5)` is
equivalent to `Inclusivity(1)`.
"""

function Inclusivity(i::Integer)
    depwarn(
        "`Inclusivity(::Integer)` is deprecated and has no direct replacement. " *
        "See `Interval` or `AnchoredInterval` constructors for alternatives.",
        :Inclusivity,
    )
    return Inclusivity(i & 0b01 > 0, i & 0b10 > 0; ignore_depwarn=true)
end

function Base.copy(x::Inclusivity)
    depwarn(
        "`copy(::Inclusivity)` is deprecated and has no direct replacement. " *
        "See `Interval` or `AnchoredInterval` constructors for alternatives.",
        :copy,
    )
    return Inclusivity(x.lowerbound, x.upperbound; ignore_depwarn=true)
end

function Base.convert(::Type{I}, x::Inclusivity) where I <: Integer
    return I(x.upperbound << 1 + x.lowerbound)
end

Base.broadcastable(i::Inclusivity) = Ref(i)

lowerbound(x::Inclusivity) = x.lowerbound
upperbound(x::Inclusivity) = x.upperbound

isclosed(x::Inclusivity) = lowerbound(x) && upperbound(x)
Base.isopen(x::Inclusivity) = !(lowerbound(x) || upperbound(x))

Base.isless(a::Inclusivity, b::Inclusivity) = isless(convert(Int, a), convert(Int, b))

function Base.show(io::IO, x::T) where T <: Inclusivity
    if get(io, :compact, false)
        print(io, x)
    else
        print(io, "$T($(x.lowerbound), $(x.upperbound))")
    end
end

function Base.print(io::IO, x::Inclusivity)
    open_char = lowerbound(x) ? '[' : '('
    close_char = upperbound(x) ? ']' : ')'
    desc = isclosed(x) ? "Closed" : isopen(x) ? "Open" : lowerbound(x) ? "Lower" : "Upper"
    print(io, "Inclusivity ", open_char, desc, close_char)
end
