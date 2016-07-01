import Base: show

abstract AbstractModels
abstract QuCircuit<:AbstractModels
abstract AbstractOp{T,N}

type QuState
    s::Vector
end

function show(io::IO,s::QuState)
end

##################################
#  Matrix Operators
##################################

type MatrixOp{N}<:AbstractOp{AbstractMatrix,N}
    name::AbstractString
    mat::AbstractMatrix
end

MatrixOp(num::Integer,name::AbstractString,mat::AbstractMatrix) =
    MatrixOp{num}(name,mat)

function show{N}(io::IO,matop::MatrixOp{N})
    println("$N bits matrix operator $(matop.name):")
    show(matop.mat)
end


OP_Hadamard = MatrixOp(2,"Hadamard",hadamard)
# Pauli Groups
OP_sigmax   = MatrixOp(2,"Pauli Sigma X",σ₁)
OP_sigmay   = MatrixOp(2,"Pauli Sigma Y",σ₂)
OP_sigmaz   = MatrixOP(2,"Pauli Sigma Z",σ₃)

# TODO
# this comes from linalg/uniformscaling.jl
# same operators should be overloaded
immutable IdentityOp{T<:Number}<:AbstractOp{T,N}
    λ::T
end

OP_I = IdentityOp(1)

##################################
# Function Operators
##################################

type FunctionOp{N}<:AbstractOp{Function,N}
    name::AbstractString
    f::Function
end


type Gate{T,N}
    name::AbstractString
    op::AbstractOp{T,N}
end

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
