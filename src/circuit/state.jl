# TODO: QuIDD

abstract AbstractQuArray{N}

type QuIDDState{N}<:AbstractQuArray{N}
end

type QuState{N}<:AbstractQuArray{N}
    s::AbstractVector
end


# TODO show(io::IO,state::QuState)
