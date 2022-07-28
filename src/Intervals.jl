module Intervals

using Dates
using Printf
using RecipesBase
using Serialization: Serialization, AbstractSerializer, deserialize
using TimeZones

using Dates: AbstractDateTime, value, coarserperiod

import Base: ⊆, ⊇, ⊈, ⊉, union, union!, merge

abstract type Boundedness end
abstract type Bounded <: Boundedness end
struct Closed <: Bounded end
struct Open <: Bounded end
struct Unbounded <: Boundedness end

bound_type(x::Bool) = x ? Closed : Open

abstract type AbstractInterval{T, L <: Boundedness, U <: Boundedness} end

Base.eltype(::AbstractInterval{T}) where {T} = T
Base.broadcastable(x::AbstractInterval) = Ref(x)
boundedness(x::AbstractInterval{T,L,U}) where {T,L,U} = (L, U)

include("isfinite.jl")
include("bounds.jl")
include("interval.jl")
include("interval_sets.jl")
include("anchoredinterval.jl")
include("parse.jl")
include("description.jl")
include("plotting.jl")
include("docstrings.jl")
include("deprecated.jl")
include("compat.jl")

export Boundedness,
       Closed,
       Open,
       Unbounded,
       AbstractInterval,
       Interval,
       IntervalSet,
       AnchoredInterval,
       HourEnding,
       HourBeginning,
       HE,
       HB,
       lowerbound,
       upperbound,
       span,
       boundedness,
       isclosed,
       anchor,
       merge,
       union,
       union!,
       less_than_disjoint,
       greater_than_disjoint,
       superset,
       .., ≪, ≫, ⊆, ⊇, ⊈, ⊉
end
