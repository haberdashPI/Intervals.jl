using Intervals: Bound, Lower, Upper, LowerBound, UpperBound

@testset "Bound" begin
    @testset "constructors" begin
        for D in (Lower, Upper)
            @test Bound{Int, D, Closed}(0).bound == 0
            @test Bound{Int, D, Open}(0).bound == 0
            @test Bound{Int, D, Unbounded}(nothing).bound isa Int

            @test_throws MethodError Bound{Int, D, Closed}(nothing)
            @test_throws MethodError Bound{Int, D, Open}(nothing)
            @test_throws MethodError Bound{Int, D, Unbounded}(0)

            @test_throws MethodError Bound{Nothing, D, Closed}(nothing)
            @test_throws MethodError Bound{Nothing, D, Open}(nothing)
            @test Bound{Nothing, D, Unbounded}(nothing).bound === nothing

            @test Bound{Int, D, Closed}(0.0).bound == 0
            @test Bound{Int, D, Open}(0.0).bound == 0
            @test_throws MethodError Bound{Int, D, Unbounded}(0.0)
        end
    end

    @testset "bounded" begin
        @testset "LowerBound < LowerBound" begin
            @test LowerBound{Open}(1) < LowerBound{Open}(2.0)
            @test LowerBound{Closed}(1) < LowerBound{Open}(2.0)
            @test LowerBound{Open}(1) < LowerBound{Closed}(2.0)
            @test LowerBound{Closed}(1) < LowerBound{Closed}(2.0)

            @test !(LowerBound{Open}(1) < LowerBound{Open}(1.0))
            @test LowerBound{Closed}(1) < LowerBound{Open}(1.0)
            @test !(LowerBound{Open}(1) < LowerBound{Closed}(1.0))
            @test !(LowerBound{Closed}(1) < LowerBound{Closed}(1.0))

            @test !(LowerBound{Open}(2) < LowerBound{Open}(1.0))
            @test !(LowerBound{Closed}(2) < LowerBound{Open}(1.0))
            @test !(LowerBound{Open}(2) < LowerBound{Closed}(1.0))
            @test !(LowerBound{Closed}(2) < LowerBound{Closed}(1.0))
        end

        @testset "LowerBound <= LowerBound" begin
            @test LowerBound{Open}(1) <= LowerBound{Open}(2.0)
            @test LowerBound{Closed}(1) <= LowerBound{Open}(2.0)
            @test LowerBound{Open}(1) <= LowerBound{Closed}(2.0)
            @test LowerBound{Closed}(1) <= LowerBound{Closed}(2.0)

            @test LowerBound{Open}(1) <= LowerBound{Open}(1.0)
            @test LowerBound{Closed}(1) <= LowerBound{Open}(1.0)
            @test !(LowerBound{Open}(1) <= LowerBound{Closed}(1.0))
            @test LowerBound{Closed}(1) <= LowerBound{Closed}(1.0)

            @test !(LowerBound{Open}(2) <= LowerBound{Open}(1.0))
            @test !(LowerBound{Closed}(2) <= LowerBound{Open}(1.0))
            @test !(LowerBound{Open}(2) <= LowerBound{Closed}(1.0))
            @test !(LowerBound{Closed}(2) <= LowerBound{Closed}(1.0))
        end

        @testset "UpperBound < UpperBound" begin
            @test UpperBound{Open}(1) < UpperBound{Open}(2.0)
            @test UpperBound{Closed}(1) < UpperBound{Open}(2.0)
            @test UpperBound{Open}(1) < UpperBound{Closed}(2.0)
            @test UpperBound{Closed}(1) < UpperBound{Closed}(2.0)

            @test !(UpperBound{Open}(1) < UpperBound{Open}(1.0))
            @test !(UpperBound{Closed}(1) < UpperBound{Open}(1.0))
            @test UpperBound{Open}(1) < UpperBound{Closed}(1.0)
            @test !(UpperBound{Closed}(1) < UpperBound{Closed}(1.0))

            @test !(UpperBound{Open}(2) < UpperBound{Open}(1.0))
            @test !(UpperBound{Closed}(2) < UpperBound{Open}(1.0))
            @test !(UpperBound{Open}(2) < UpperBound{Closed}(1.0))
            @test !(UpperBound{Closed}(2) < UpperBound{Closed}(1.0))
        end

        @testset "UpperBound <= UpperBound" begin
            @test UpperBound{Open}(1) <= UpperBound{Open}(2.0)
            @test UpperBound{Closed}(1) <= UpperBound{Open}(2.0)
            @test UpperBound{Open}(1) <= UpperBound{Closed}(2.0)
            @test UpperBound{Closed}(1) <= UpperBound{Closed}(2.0)

            @test UpperBound{Open}(1) <= UpperBound{Open}(1.0)
            @test !(UpperBound{Closed}(1) <= UpperBound{Open}(1.0))
            @test UpperBound{Open}(1) <= UpperBound{Closed}(1.0)
            @test UpperBound{Closed}(1) <= UpperBound{Closed}(1.0)

            @test !(UpperBound{Open}(2) <= UpperBound{Open}(1.0))
            @test !(UpperBound{Closed}(2) <= UpperBound{Open}(1.0))
            @test !(UpperBound{Open}(2) <= UpperBound{Closed}(1.0))
            @test !(UpperBound{Closed}(2) <= UpperBound{Closed}(1.0))
        end

        @testset "LowerBound < UpperBound" begin
            @test LowerBound{Open}(1) < UpperBound{Open}(2.0)
            @test LowerBound{Closed}(1) < UpperBound{Open}(2.0)
            @test LowerBound{Open}(1) < UpperBound{Closed}(2.0)
            @test LowerBound{Closed}(1) < UpperBound{Closed}(2.0)

            @test !(LowerBound{Open}(1) < UpperBound{Open}(1.0))
            @test !(LowerBound{Closed}(1) < UpperBound{Open}(1.0))
            @test !(LowerBound{Open}(1) < UpperBound{Closed}(1.0))
            @test !(LowerBound{Closed}(1) < UpperBound{Closed}(1.0))

            @test !(LowerBound{Open}(2) < UpperBound{Open}(1.0))
            @test !(LowerBound{Closed}(2) < UpperBound{Open}(1.0))
            @test !(LowerBound{Open}(2) < UpperBound{Closed}(1.0))
            @test !(LowerBound{Closed}(2) < UpperBound{Closed}(1.0))
        end

        @testset "LowerBound <= UpperBound" begin
            @test LowerBound{Open}(1) <= UpperBound{Open}(2.0)
            @test LowerBound{Closed}(1) <= UpperBound{Open}(2.0)
            @test LowerBound{Open}(1) <= UpperBound{Closed}(2.0)
            @test LowerBound{Closed}(1) <= UpperBound{Closed}(2.0)

            @test !(LowerBound{Open}(1) <= UpperBound{Open}(1.0))
            @test !(LowerBound{Closed}(1) <= UpperBound{Open}(1.0))
            @test !(LowerBound{Open}(1) <= UpperBound{Closed}(1.0))
            @test LowerBound{Closed}(1) <= UpperBound{Closed}(1.0)

            @test !(LowerBound{Open}(2) <= UpperBound{Open}(1.0))
            @test !(LowerBound{Closed}(2) <= UpperBound{Open}(1.0))
            @test !(LowerBound{Open}(2) <= UpperBound{Closed}(1.0))
            @test !(LowerBound{Closed}(2) <= UpperBound{Closed}(1.0))
        end

        @testset "UpperBound < LowerBound" begin
            @test UpperBound{Open}(1) < LowerBound{Open}(2.0)
            @test UpperBound{Closed}(1) < LowerBound{Open}(2.0)
            @test UpperBound{Open}(1) < LowerBound{Closed}(2.0)
            @test UpperBound{Closed}(1) < LowerBound{Closed}(2.0)

            @test UpperBound{Open}(1) < LowerBound{Open}(1.0)
            @test UpperBound{Closed}(1) < LowerBound{Open}(1.0)
            @test UpperBound{Open}(1) < LowerBound{Closed}(1.0)
            @test !(UpperBound{Closed}(1) < LowerBound{Closed}(1.0))

            @test !(UpperBound{Open}(2) < LowerBound{Open}(1.0))
            @test !(UpperBound{Closed}(2) < LowerBound{Open}(1.0))
            @test !(UpperBound{Open}(2) < LowerBound{Closed}(1.0))
            @test !(UpperBound{Closed}(2) < LowerBound{Closed}(1.0))
        end

        @testset "UpperBound <= LowerBound" begin
            @test UpperBound{Open}(1) <= LowerBound{Open}(2.0)
            @test UpperBound{Closed}(1) <= LowerBound{Open}(2.0)
            @test UpperBound{Open}(1) <= LowerBound{Closed}(2.0)
            @test UpperBound{Closed}(1) <= LowerBound{Closed}(2.0)

            @test UpperBound{Open}(1) <= LowerBound{Open}(1.0)
            @test UpperBound{Closed}(1) <= LowerBound{Open}(1.0)
            @test UpperBound{Open}(1) <= LowerBound{Closed}(1.0)
            @test UpperBound{Closed}(1) <= LowerBound{Closed}(1.0)

            @test !(UpperBound{Open}(2) <= LowerBound{Open}(1.0))
            @test !(UpperBound{Closed}(2) <= LowerBound{Open}(1.0))
            @test !(UpperBound{Open}(2) <= LowerBound{Closed}(1.0))
            @test !(UpperBound{Closed}(2) <= LowerBound{Closed}(1.0))
        end

        @testset "$T < Scalar" for T in (LowerBound, UpperBound)
            @test T{Open}(1) < 2.0
            @test T{Closed}(1) < 2.0

            @test (T{Open}(1) < 1.0) == (T === UpperBound)
            @test !(T{Closed}(1) < 1.0)

            @test !(T{Open}(1) < 0.0)
            @test !(T{Closed}(1) < 0.0)
        end

        @testset "$T <= Scalar" for T in (LowerBound, UpperBound)
            @test T{Open}(1) <= 2.0
            @test T{Closed}(1) <= 2.0

            @test (T{Open}(1) <= 1.0) == (T === UpperBound)
            @test T{Closed}(1) <= 1.0

            @test !(T{Open}(1) <= 0.0)
            @test !(T{Closed}(1) <= 0.0)
        end

        @testset "Scalar < $T" for T in (LowerBound, UpperBound)
            @test 0 < T{Open}(1.0)
            @test 0 < T{Closed}(1.0)

            @test (1 < T{Open}(1.0)) == (T === LowerBound)
            @test !(1 < T{Closed}(1.0))

            @test !(2 < T{Open}(1.0))
            @test !(2 < T{Closed}(1.0))
        end

        @testset "Scalar <= $T" for T in (LowerBound, UpperBound)
            @test 0 <= T{Open}(1.0)
            @test 0 <= T{Closed}(1.0)

            @test (1 <= T{Open}(1.0)) == (T === LowerBound)
            @test 1 <= T{Closed}(1.0)

            @test !(2 <= T{Open}(1.0))
            @test !(2 <= T{Closed}(1.0))
        end

        @testset "LowerBound == LowerBound" begin
            @test LowerBound{Open}(1) != LowerBound{Open}(2.0)
            @test LowerBound{Closed}(1) != LowerBound{Open}(2.0)
            @test LowerBound{Open}(1) != LowerBound{Closed}(2.0)
            @test LowerBound{Closed}(1) != LowerBound{Closed}(2.0)

            @test LowerBound{Open}(1) == LowerBound{Open}(1.0)
            @test LowerBound{Closed}(1) != LowerBound{Open}(1.0)
            @test LowerBound{Open}(1) != LowerBound{Closed}(1.0)
            @test LowerBound{Closed}(1) == LowerBound{Closed}(1.0)
        end

        @testset "UpperBound == UpperBound" begin
            @test UpperBound{Open}(1) != UpperBound{Open}(2.0)
            @test UpperBound{Closed}(1) != UpperBound{Open}(2.0)
            @test UpperBound{Open}(1) != UpperBound{Closed}(2.0)
            @test UpperBound{Closed}(1) != UpperBound{Closed}(2.0)

            @test UpperBound{Open}(1) == UpperBound{Open}(1.0)
            @test UpperBound{Closed}(1) != UpperBound{Open}(1.0)
            @test UpperBound{Open}(1) != UpperBound{Closed}(1.0)
            @test UpperBound{Closed}(1) == UpperBound{Closed}(1.0)
        end

        @testset "LowerBound == UpperBound" begin
            @test LowerBound{Open}(1) != UpperBound{Open}(2.0)
            @test LowerBound{Closed}(1) != UpperBound{Open}(2.0)
            @test LowerBound{Open}(1) != UpperBound{Closed}(2.0)
            @test LowerBound{Closed}(1) != UpperBound{Closed}(2.0)

            @test LowerBound{Open}(1) != UpperBound{Open}(1.0)
            @test LowerBound{Closed}(1) != UpperBound{Open}(1.0)
            @test LowerBound{Open}(1) != UpperBound{Closed}(1.0)
            @test LowerBound{Closed}(1) == UpperBound{Closed}(1.0)
        end

        @testset "UpperBound == LowerBound" begin
            @test UpperBound{Open}(1) != LowerBound{Open}(2.0)
            @test UpperBound{Closed}(1) != LowerBound{Open}(2.0)
            @test UpperBound{Open}(1) != LowerBound{Closed}(2.0)
            @test UpperBound{Closed}(1) != LowerBound{Closed}(2.0)

            @test UpperBound{Open}(1) != LowerBound{Open}(1.0)
            @test UpperBound{Closed}(1) != LowerBound{Open}(1.0)
            @test UpperBound{Open}(1) != LowerBound{Closed}(1.0)
            @test UpperBound{Closed}(1) == LowerBound{Closed}(1.0)
        end

        @testset "$T == Scalar" for T in (LowerBound, UpperBound)
            @test T{Open}(0) != 1.0
            @test T{Closed}(0) != 1.0

            @test T{Open}(1) != 1.0
            @test T{Closed}(1) == 1.0

            @test T{Open}(2) != 1.0
            @test T{Closed}(2) != 1.0
        end

        @testset "Scalar == $T" for T in (LowerBound, UpperBound)
            @test 1.0 != T{Open}(0)
            @test 1.0 != T{Closed}(0)

            @test 1.0 != T{Open}(1)
            @test 1.0 == T{Closed}(1)

            @test 1.0 != T{Open}(2)
            @test 1.0 != T{Closed}(2)
        end

        @testset "isequal" begin
            @test isequal(LowerBound{Closed}(0.0), LowerBound{Closed}(0.0))
            @test isequal(LowerBound{Open}(0.0), LowerBound{Open}(0.0))
            @test !isequal(LowerBound{Closed}(-0.0), LowerBound{Open}(0.0))
            @test !isequal(LowerBound{Open}(-0.0), LowerBound{Closed}(0.0))
            @test !isequal(LowerBound{Closed}(-0.0), LowerBound{Closed}(0.0))
            @test !isequal(LowerBound{Open}(-0.0), LowerBound{Open}(0.0))

            @test isequal(UpperBound{Closed}(0.0), LowerBound{Closed}(0.0))
            @test !isequal(LowerBound{Closed}(-0.0), UpperBound{Open}(0.0))
            @test !isequal(UpperBound{Open}(-0.0), LowerBound{Closed}(0.0))
            @test !isequal(LowerBound{Closed}(-0.0), UpperBound{Closed}(0.0))
        end

        @testset "hash" begin
            # Need a complicated enough element type for this test to possibly fail. Using a
            # ZonedDateTime with a VariableTimeZone should do the trick.
            a = now(tz"Europe/London")
            b = deepcopy(a)
            @test hash(a) == hash(b)  # Double check

            @test hash(LowerBound{Open}(a)) == hash(LowerBound{Open}(b))
            @test hash(LowerBound{Closed}(a)) != hash(LowerBound{Open}(b))
            @test hash(LowerBound{Open}(a)) != hash(LowerBound{Closed}(b))
            @test hash(LowerBound{Closed}(a)) == hash(LowerBound{Closed}(b))

            @test hash(UpperBound{Open}(a)) == hash(UpperBound{Open}(b))
            @test hash(UpperBound{Closed}(a)) != hash(UpperBound{Open}(b))
            @test hash(UpperBound{Open}(a)) != hash(UpperBound{Closed}(b))
            @test hash(UpperBound{Closed}(a)) == hash(UpperBound{Closed}(b))

            @test hash(LowerBound{Open}(a)) != hash(UpperBound{Open}(b))
            @test hash(LowerBound{Closed}(a)) != hash(UpperBound{Open}(b))
            @test hash(LowerBound{Open}(a)) != hash(UpperBound{Closed}(b))
            @test hash(LowerBound{Closed}(a)) != hash(UpperBound{Closed}(b))
        end
    end

    # Note: The value for unbounded bounds is irrelevant
    @testset "unbounded" begin
        @testset "LowerBound < LowerBound" begin
            @test !(LowerBound{Unbounded}(nothing) < LowerBound{Unbounded}(nothing))
            @test LowerBound{Unbounded}(nothing) < LowerBound{Open}(0.0)
            @test LowerBound{Unbounded}(nothing) < LowerBound{Closed}(0.0)
            @test !(LowerBound{Open}(0) < LowerBound{Unbounded}(nothing))
            @test !(LowerBound{Closed}(0) < LowerBound{Unbounded}(nothing))
        end

        @testset "LowerBound <= LowerBound" begin
            @test LowerBound{Unbounded}(nothing) <= LowerBound{Unbounded}(nothing)
            @test LowerBound{Unbounded}(nothing) <= LowerBound{Open}(0.0)
            @test LowerBound{Unbounded}(nothing) <= LowerBound{Closed}(0.0)
            @test !(LowerBound{Open}(0) <= LowerBound{Unbounded}(nothing))
            @test !(LowerBound{Closed}(0) <= LowerBound{Unbounded}(nothing))
        end

        @testset "UpperBound < UpperBound" begin
            @test !(UpperBound{Unbounded}(nothing) < UpperBound{Unbounded}(nothing))
            @test !(UpperBound{Unbounded}(nothing) < UpperBound{Open}(0.0))
            @test !(UpperBound{Unbounded}(nothing) < UpperBound{Closed}(0.0))
            @test UpperBound{Open}(0) < UpperBound{Unbounded}(nothing)
            @test UpperBound{Closed}(0) < UpperBound{Unbounded}(nothing)
        end

        @testset "UpperBound <= UpperBound" begin
            @test UpperBound{Unbounded}(nothing) <= UpperBound{Unbounded}(nothing)
            @test !(UpperBound{Unbounded}(nothing) <= UpperBound{Open}(0.0))
            @test !(UpperBound{Unbounded}(nothing) <= UpperBound{Closed}(0.0))
            @test UpperBound{Open}(0) <= UpperBound{Unbounded}(nothing)
            @test UpperBound{Closed}(0) <= UpperBound{Unbounded}(nothing)
        end

        @testset "LowerBound < UpperBound" begin
            @test LowerBound{Unbounded}(nothing) < UpperBound{Unbounded}(nothing)
            @test LowerBound{Unbounded}(nothing) < UpperBound{Open}(0.0)
            @test LowerBound{Unbounded}(nothing) < UpperBound{Closed}(0.0)
            @test LowerBound{Open}(0) < UpperBound{Unbounded}(nothing)
            @test LowerBound{Closed}(0) < UpperBound{Unbounded}(nothing)
        end

        @testset "LowerBound <= UpperBound" begin
            @test LowerBound{Unbounded}(nothing) <= UpperBound{Unbounded}(nothing)
            @test LowerBound{Unbounded}(nothing) <= UpperBound{Open}(0.0)
            @test LowerBound{Unbounded}(nothing) <= UpperBound{Closed}(0.0)
            @test LowerBound{Open}(0) <= UpperBound{Unbounded}(nothing)
            @test LowerBound{Closed}(0) <= UpperBound{Unbounded}(nothing)
        end

        @testset "UpperBound < LowerBound" begin
            @test !(UpperBound{Unbounded}(nothing) < LowerBound{Unbounded}(nothing))
            @test !(UpperBound{Unbounded}(nothing) < LowerBound{Open}(0.0))
            @test !(UpperBound{Unbounded}(nothing) < LowerBound{Closed}(0.0))
            @test !(UpperBound{Open}(0) < LowerBound{Unbounded}(nothing))
            @test !(UpperBound{Closed}(0) < LowerBound{Unbounded}(nothing))
        end

        @testset "UpperBound <= LowerBound" begin
            @test !(UpperBound{Unbounded}(nothing) < LowerBound{Unbounded}(nothing))
            @test !(UpperBound{Unbounded}(nothing) < LowerBound{Open}(0.0))
            @test !(UpperBound{Unbounded}(nothing) < LowerBound{Closed}(0.0))
            @test !(UpperBound{Open}(0) < LowerBound{Unbounded}(nothing))
            @test !(UpperBound{Closed}(0) < LowerBound{Unbounded}(nothing))
        end

        @testset "LowerBound < Scalar" begin
            @test LowerBound{Unbounded}(nothing) < -Inf
            @test LowerBound{Unbounded}(nothing) < Inf
        end

         @testset "LowerBound <= Scalar" begin
            @test LowerBound{Unbounded}(nothing) <= -Inf
            @test LowerBound{Unbounded}(nothing) <= Inf
        end

        @testset "UpperBound < Scalar" begin
            @test !(UpperBound{Unbounded}(nothing) < -Inf)
            @test !(UpperBound{Unbounded}(nothing) < Inf)
        end

        @testset "UpperBound <= Scalar" begin
            @test !(UpperBound{Unbounded}(nothing) <= -Inf)
            @test !(UpperBound{Unbounded}(nothing) <= Inf)
        end

        @testset "Scalar < LowerBound" begin
            @test !(-Inf < LowerBound{Unbounded}(nothing))
            @test !(Inf < LowerBound{Unbounded}(nothing))
        end

        @testset "Scalar <= LowerBound" begin
            @test !(-Inf <= LowerBound{Unbounded}(nothing))
            @test !(Inf <= LowerBound{Unbounded}(nothing))
        end

        @testset "Scalar < UpperBound" begin
            @test -Inf < UpperBound{Unbounded}(nothing)
            @test Inf < UpperBound{Unbounded}(nothing)
        end

        @testset "Scalar < UpperBound" begin
            @test -Inf <= UpperBound{Unbounded}(nothing)
            @test Inf <= UpperBound{Unbounded}(nothing)
        end

        @testset "LowerBound == LowerBound" begin
            @test LowerBound{Unbounded}(nothing) == LowerBound{Unbounded}(nothing)
            @test LowerBound{Unbounded}(nothing) != LowerBound{Open}(0.0)
            @test LowerBound{Unbounded}(nothing) != LowerBound{Closed}(0.0)
            @test LowerBound{Open}(0) != LowerBound{Unbounded}(nothing)
            @test LowerBound{Closed}(0) != LowerBound{Unbounded}(nothing)
        end

        @testset "UpperBound == UpperBound" begin
            @test UpperBound{Unbounded}(nothing) == UpperBound{Unbounded}(nothing)
            @test UpperBound{Unbounded}(nothing) != UpperBound{Open}(0.0)
            @test UpperBound{Unbounded}(nothing) != UpperBound{Closed}(0.0)
            @test UpperBound{Open}(0) != UpperBound{Unbounded}(nothing)
            @test UpperBound{Closed}(0) != UpperBound{Unbounded}(nothing)
        end

        @testset "LowerBound == UpperBound" begin
            @test LowerBound{Unbounded}(nothing) != UpperBound{Unbounded}(nothing)
            @test LowerBound{Unbounded}(nothing) != UpperBound{Open}(0.0)
            @test LowerBound{Unbounded}(nothing) != UpperBound{Closed}(0.0)
            @test LowerBound{Open}(0) != UpperBound{Unbounded}(nothing)
            @test LowerBound{Closed}(0) != UpperBound{Unbounded}(nothing)
        end

        @testset "UpperBound == LowerBound" begin
            @test UpperBound{Unbounded}(nothing) != LowerBound{Unbounded}(nothing)
            @test UpperBound{Unbounded}(nothing) != LowerBound{Open}(0.0)
            @test UpperBound{Unbounded}(nothing) != LowerBound{Closed}(0.0)
            @test UpperBound{Open}(0) != LowerBound{Unbounded}(nothing)
            @test UpperBound{Closed}(0) != LowerBound{Unbounded}(nothing)
        end

        @testset "isequal" begin
            T = Float64

            @test isequal(LowerBound{T,Unbounded}(nothing), LowerBound{T,Unbounded}(nothing))
            @test !isequal(LowerBound{T,Unbounded}(nothing), LowerBound{T,Open}(0.0))
            @test !isequal(LowerBound{T,Unbounded}(nothing), LowerBound{T,Closed}(0.0))
            @test !isequal(LowerBound{T,Open}(-0.0), LowerBound{T,Unbounded}(nothing))
            @test !isequal(LowerBound{T,Closed}(-0.0), LowerBound{T,Unbounded}(nothing))

            @test !isequal(UpperBound{Unbounded}(nothing), LowerBound{Unbounded}(nothing))
            @test !isequal(LowerBound{Unbounded}(nothing), UpperBound{Unbounded}(nothing))
        end

         @testset "hash" begin
            # Note: Unbounded bounds should ignore the value
            T = Int

            lower_unbounded = LowerBound{T,Unbounded}(nothing)
            @test hash(lower_unbounded) == hash(LowerBound{T,Unbounded}(nothing))
            @test hash(lower_unbounded) != hash(LowerBound{Unbounded}(nothing))
            @test hash(lower_unbounded) != hash(LowerBound{Open}(lower_unbounded.bound))
            @test hash(lower_unbounded) != hash(LowerBound{Closed}(lower_unbounded.bound))

            upper_unbounded = UpperBound{T,Unbounded}(nothing)
            @test hash(upper_unbounded) == hash(UpperBound{T,Unbounded}(nothing))
            @test hash(upper_unbounded) != hash(UpperBound{Unbounded}(nothing))
            @test hash(upper_unbounded) != hash(UpperBound{Open}(upper_unbounded.bound))
            @test hash(upper_unbounded) != hash(UpperBound{Closed}(upper_unbounded.bound))

            @test hash(LowerBound{T,Unbounded}(nothing)) != hash(UpperBound{T,Unbounded}(nothing))
            @test hash(LowerBound{T,Unbounded}(nothing)) != hash(UpperBound{T,Open}(0))
            @test hash(LowerBound{T,Unbounded}(nothing)) != hash(UpperBound{T,Closed}(0))
            @test hash(LowerBound{T,Open}(0)) != hash(UpperBound{T,Unbounded}(nothing))
            @test hash(LowerBound{T,Closed}(0)) != hash(UpperBound{T,Unbounded}(nothing))
        end
    end

    @testset "broadcast" begin
        test = [
            LowerBound{Open}(0),
            LowerBound{Closed}(0),
            LowerBound{Unbounded}(nothing),
            UpperBound{Open}(0),
            UpperBound{Closed}(0),
            UpperBound{Unbounded}(nothing),
        ]

        # Verify that Bound is treated as a scalar during broadcast
        result = test .== 0
        @test result == [false, true, false, false, true, false]
    end
end
