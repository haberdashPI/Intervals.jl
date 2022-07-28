# Note: Terminology overall taken from:
# https://en.wikipedia.org/wiki/Interval_(mathematics)#Terminology

"""
    Boundedness <: Any

Abstract type representing all possible endpoint classifications (e.g. open, closed,
unbounded).
"""
:Boundedness

"""
    Bounded <: Boundedness

Abstract type indicating that the endpoint of an interval is not unbounded (e.g. open or
closed).
"""
:Bounded

"""
    Closed <: Bounded <: Boundedness

Type indicating that the endpoint of an interval is closed (the endpoint value is *included*
in the interval).
"""
:Closed

"""
    Open <: Bounded <: Boundedness

Type indicating that the endpoint of an interval is open (the endpoint value is *not
included* in the interval).
"""
:Open

"""
    Unbounded <: Boundedness

Type indicating that the endpoint of an interval is unbounded (the endpoint value is
effectively infinite).
"""
:Unbounded

"""
    LowerBound <: Bound

Represents the lower endpoint of an `AbstractInterval`. Useful for comparing two endpoints
to each other.

### Examples

```jldoctest; setup = :(using Intervals; using Intervals: LowerBound)
julia> LowerBound(Interval(0.0, 1.0))
Intervals.Bound{Float64, Intervals.Direction{:Lower}(), Closed}(0.0)

julia> LowerBound{Closed}(1.0)
Intervals.Bound{Float64, Intervals.Direction{:Lower}(), Closed}(1.0)

julia> LowerBound{Closed}(1) < LowerBound{Closed}(2)
true

julia> LowerBound{Closed}(0) < LowerBound{Open}(0)
true

julia> LowerBound{Open}(0) <= LowerBound{Closed}(0)
false
```

See also: [`UpperBound`](@ref)
"""
:LowerBound

"""
    UpperBound <: Bound

Represents the upper endpoint of an `AbstractInterval`. Useful for comparing two endpoints
to each other.

### Examples

```jldoctest; setup = :(using Intervals; using Intervals: UpperBound)
julia> UpperBound(Interval(0.0, 1.0))
Intervals.Bound{Float64, Intervals.Direction{:Upper}(), Closed}(1.0)

julia> UpperBound{Closed}(1.0)
Intervals.Bound{Float64, Intervals.Direction{:Upper}(), Closed}(1.0)

julia> UpperBound{Closed}(1) < UpperBound{Closed}(2)
true

julia> UpperBound{Open}(0) < UpperBound{Closed}(0)
true

julia> UpperBound{Closed}(0) <= UpperBound{Open}(0)
false
```

See also: [`LowerBound`](@ref)
"""
:UpperBound

"""
    lowerbound(interval::AbstractInterval{T}) -> Union{T,Nothing}

The value of the lower endpoint. When the lower endpoint is unbounded `nothing` will be
returned.
"""
lowerbound(::AbstractInterval)

"""
    upperbound(interval::AbstractInterval{T}) -> Union{T,Nothing}

The value of the upper endpoint. When the upper endpoint is unbounded `nothing` will be
returned.
"""
upperbound(::AbstractInterval)

"""
    span(interval::AbstractInterval) -> Any

The delta between the upper and lower endpoints. For bounded intervals returns a
non-negative value while intervals with any unbounded endpoints will throw an
`ArgumentError`.

To avoid having to capture the exception use the pattern:
```julia
Intervals.isbounded(interval) ? span(interval) : infinity
```
Where `infinity` is a variable representing the value you wish to use to represent an
unbounded, or infinite, span.
"""
span(::AbstractInterval)

"""
    isclosed(interval) -> Bool

Is a closed-interval: includes both of its endpoints.
"""
isclosed(::AbstractInterval)

"""
    isopen(interval) -> Bool

Is an open-interval: excludes both of its endpoints.
"""
Base.isopen(::AbstractInterval)

"""
    isunbounded(interval) -> Bool

Is an unbounded-interval: unbounded at both ends.
"""
isunbounded(::AbstractInterval)

"""
    isbounded(interval) -> Bool

Is a bounded-interval: either open, closed, lower-closed/upper-open, or
lower-open/upper-closed.

Note using `!isbounded` is commonly used to determine if any end of the interval is
unbounded.
"""
isbounded(::AbstractInterval)

"""
    minimum(interval::AbstractInterval{T}; [increment]) -> T

The minimum value contained within the `interval`.

If lower-closed, returns `lowerbound(interval)`.
If lower-open, returns `lowerbound(interval) + eps(lowerbound(interval))`
If lower-unbounded, returns minimum value possible for type `T`.

A `BoundsError` is thrown for empty intervals or when the increment results in a minimum value
not-contained by the interval.
"""
minimum(::AbstractInterval; increment)

"""
    maximum(interval::AbstractInterval{T}; [increment]) -> T

The maximum value contained within the `interval`.

If upper-closed, returns `upperbound(interval)`.
If upper-open, returns `lowerbound(interval) + eps(lowerbound(interval))`
If upper-unbounded, returns maximum value possible for type `T`.

A `BoundsError` is thrown for empty intervals or when the increment results in a maximum value
not-contained by the interval.
"""
maximum(::AbstractInterval; increment)
