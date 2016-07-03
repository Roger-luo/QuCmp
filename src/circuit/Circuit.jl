using Expokit
import Base: show

abstract AbstractModels
abstract QuCircuit<:AbstractModels
abstract AbstractOp{T,N}

type QuState{N}
    s::AbstractVector
end

# TODO show(io::IO,state::QuState)

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
immutable IdentityOp{T<:Number}<:AbstractOp{T}
    λ::T
end

OP_I = IdentityOp(1)

##################################
# Function Operators
##################################

const FUNCTION_OP_PARA_INF -1

type FunctionOp{N}<:AbstractOp{Function,N}
    name::AbstractString
    f::Function
end

function TimeOp{N}(state::QuState{N};Hamiltonian=I,dt=1e-6)
    return expmv(-im*dt,Hamiltonian,state.s)
end

type Gate{T,N}
    name::AbstractString
    op::AbstractOp{T,N}
end

Gate{T,N}(name::AbstractString,op::MatrixOP{N})=Gate{AbstractMatrix,N}(name,op)

Hadamard = Gate("Hadamard gate",OP_Hadamard)
X        = Gate("Paili X",OP_sigmax)
Y        = Gate("Paili Y",OP_sigmay)
Z        = Gate("Paili Z",OP_sigmaz)


"""
GateUnit
---

GateUnit is for the gate unit in a circuit

pos:
the first number in pos is the the column number
the second number in pos is the bits' IDs that is realted to this gate
eg.

'''
  --block 1--|----block 2----|
1 -----------|---------------|
2 ----[A]----|---------------|
3 -----------|---------------|
4 -----------|-----[   ]-----|
5 -----------|-----[ B ]-----|
6 -----------|-----[   ]-----|
'''

The position of gate B is (2,4,5,6)
"""
abstract AbstractGateUnit

type GateUnit{T,N}<:AbstractGateUnit
    pos::Vector{Int}
    gate::Gate{T,N}
    # TODO : time layer?
    # time_layer::Real

    function GateUnit{T,N}(pos::Vector{Int},gate::Gate{T,N})
end

type Circuit{T,N} <: QuCircuit
    gates::GateUnit{T,N}
end
