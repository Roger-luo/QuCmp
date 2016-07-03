using Expokit
import Base: show

abstract AbstractOp{T,N}

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
