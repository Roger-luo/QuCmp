# TODO: QuIDD

abstract AbstractQuArray{N}

type QuIDDArray{N}<:AbstractQuArray{N}
end

type QuState{N}<:AbstractQuArray{N}
    s::AbstractVector
end

(+)(A::QuState,B::QuState) = A.s+B.s
(-)(A::Qustate,B::QuState) = A.s-B.s
(*)(A::QuState,B::QuState) = A.s*B.s
(/)(A::QuState,B::QuState) = A.s/B/s
(^)(A::QuState,b::Real) = A.s^b


# TODO show(io::IO,state::QuState)
