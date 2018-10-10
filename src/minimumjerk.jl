export minimumjerk, minimumjerkf, functionform


"""
Retorna os coeficientes do polinômio de trajetória com base no princípio do minimum jerk considerando o tempo inicial sendo 0(zero).
Entradas
x0 -> posição inicial
v0 -> velocidade inicial
a0 -> aceleração inicial
t0 -> tempo inicial
xf -> posição final
vf -> velocidade final
af -> aceleração final
tf -> tempo para chegar ao ponto final
"""
function minimumjerk(x0::T, v0::T, a0::T, t0::T, xf::T, vf::T, af::T, tf::T)  where {T<:AbstractFloat}
    b=[ 1 t0 t0^2 t0^3 t0^4 t0^5;
    0 1 2*t0 3*(t0^2) 4*(t0^3) 5*(t0^4);
    0 0 2 6*t0 12*(t0^2) 20*(t0^3);
    1 tf tf^2 tf^3 tf^4 tf^5;
    0 1 2*tf 3*(tf^2) 4*(tf^3) 5*(tf^4);
    0 0 2 6*tf 12*(tf^2) 20*(tf^3)]
    c = [x0, v0, a0, xf, vf, af]
    a = inv(b)*c
    return a
end


"""
Retorna os coeficientes do polinômio de trajetória com base no princípio do minimum jerk considerando o tempo inicial sendo 0(zero).
Entradas
x0 -> posição inicial
v0 -> velocidade inicial
a0 -> aceleração inicial
xf -> posição final
vf -> velocidade final
af -> aceleração final
T -> tempo para chegar ao ponto final
"""
function minimumjerk(x0::T, v0::T, a0::T, xf::T, vf::T, af::T, tf::T) where T<:AbstractFloat
    t0 = 0
    minimumjerk(x0,v0,a0,t0,xf,vf,af,tf)
end

function minimumjerkf(x0::T, v0::T, a0::T, t0::T, xf::T, vf::T, af::T, tf::T) where T<:AbstractFloat
    functionform(minimumjerk(x0,v0,a0,t0,xf,vf,af,tf))
end

function minimumjerkf(x0::T, v0::T, a0::T, xf::T, vf::T, af::T, tf::T) where T<:AbstractFloat
    t0 = 0.0
    functionform(minimumjerk(x0,v0,a0,t0,xf,vf,af,tf))
end

# Retorna as funções de posição, velocidade, aceleração e jerk a parti dos coeficientes do polinômio do mínimo jerk
# Entradas
# a -> vetor com os coeficientes do polinômio
function functionform(a::Vector)
    @eval out1 = $(Meta.parse("t -> $(a[1]) + $(a[2])*t + $(a[3])*(t^2) + $(a[4])*(t^3) + $(a[5])*(t^4) + $(a[6])*(t^5)"))
    @eval out2 = $(Meta.parse("t -> $(a[2]) + 2*$(a[3])*t + 3*$(a[4])*(t^2) + 4*$(a[5])*(t^3) + 5*$(a[6])*(t^4)"))
    @eval out3 = $(Meta.parse("t ->  2*$(a[3]) + 6*$(a[4])*t + 12*$(a[5])*(t^2) + 20*$(a[6])*(t^3)"))
    @eval out4 = $(Meta.parse("t -> 6*$(a[4]) + 24*$(a[5])*t + 60*$(a[6])*(t^2)"))
    return out1, out2, out3, out4
end

# Retorna as funções de posição, velocidade, aceleração e jerk 
# partindo de um vetor de posições finais de cada junta e do tempo final
# essa função considera que as condições iniciais (psição, velocidade e aceleração) são
# nulas em cada junta
function minimumjerk(final_positions::Vector{T},tend::T) where T<:AbstractFloat
    xr = Function[]
    vr = Function[]
    ar = Function[]
    jr = Function[]
    for i in final_positions
        x, v, a, j = minimumjerkf(0.0, 0.0, 0.0,0.0, i, 0.0, 0.0, tend)
        push!(xr,x)
        push!(vr,v)
        push!(ar,a)
        push!(jr,j)
    end
    xr, vr, ar, jr
end    