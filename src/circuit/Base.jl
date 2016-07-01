abstract AbstractModels
abstract QuCircuit<:AbstractModels
abstract AbstractOp{T,N}

type Gate{T,N}
    name::AbstractString
    op::AbstractOp{T,N}
end

type BaseMatrixOp{N}<:AbstractOp{AbstractMatrix,N}
    name::AbstractString
    mat::AbstractMatrix
end

BaseMatrixOp(num::Integer,name::AbstractString,mat::AbstractMatrix) =
    BaseMatrixOp{num}(name,mat)

OP_Hadamard = BaseMatrixOp{2}("Hadamard",hadamard)

# TODO
# function show(io::IO,matop::BaseMatrixOp)
# end



"""
GateUnit
---

GateUnit is for the gate unit in a circuit

pos:
the first number in pos is the the column number
the second number in pos is the bits' IDs that is realted to this gate
eg.
--block 1--|----block 2----|
1 -----------|---------------|
2 --[A]------|---------------|
3 -----------|---------------|
4 -----------|---[   ]-------|
5 -----------|---[ B ]-------|
6 -----------|---[   ]-------|

The position of gate B is (2,4,5,6)
"""
abstract AbstractGateUnit

type GateUnit{T,N}<:AbstractGateUnit
    pos::Vector{Int}
    gate::Gate{T,N}
    # TODO : time layer?
    # time_layer::Real
end

type Circuit{N} <: QuCircuit
    gates::GateUnit{T,N}
end
