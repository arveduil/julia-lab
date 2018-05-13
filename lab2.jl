import Base.^
import Base.*
import Base.convert
import Base.count
import Base.promote_rule

function printGraph(t)
    queue= [t]
    while(t != Any)
        push!(queue,supertype(t))
        t=supertype(t)
    end
    for i= 1:length(queue)
        print(queue[i])
        if i != length(queue)
            print("->")
        end
    end
end


#struktura wraz z konstruktorem
struct Gn{N}
           x::Number
           Gn{N}(x) where N = new(constructor(x,N))
       end
function constructor(x,N)
    if(x>=N)
        x=x%N
    end
    if(gcd(x,N)!=1 && x>0) #x nie moze miec gcd z N rownego N
        throw(DomainError())
    end
    return x
end
#mnozenie grupy
function *{N}(A::Gn{N}, B::Gn{N})
    return Gn{N}(A.x*B.x)
  end
function *{N}(A::Gn{N}, B::Integer)
    return Gn{N}(A.x*B)
  end
function *{N}(A::Integer,B::Gn{N})
    return B*A
  end
#konwersja typu
convert{N}(::Type{Gn{N}}, x::Int64) = Gn{N}(x)
convert{N}(::Type{Int64}, x::Gn{N}) = x.x
#promocja typu
promote_rule(::Type{Gn{N}}, ::Type{T}) where {T<:Integer,N} = Gn{N}
#potegowanie
function ^{N}(Base::Gn{N},Index::Integer)
      x=Gn{N}(1)
      for i = 1:Index
             x=x*Base
         end
      return x
    end
#odwrotnosc
function inverse{N}(A::Gn{N})
        return filter(x->try convert(Int64,(A*x)) catch 0 end ==1,1:N)[1]
    end
#ilosc elementow w grupie
function count{N}(T::Type{Gn{N}})
        return length(filter(x->try convert(Int64,Gn{N}(x))==x catch false end,1:N))
    end
#okres grupy
function  period{N}(a::Gn{N})
        findfirst(elem -> (a ^ elem).x == 1, 1:N)
    end

#przykladowe obliczenie rsa:
N = 47
c = 19
b = 3

r = period(Gn{N}(b))
d = inverse(Gn{r}(c))
a = Gn{N}(b) ^ d
println("r: $r")
println("d: $d")
println("a: $a")
println("a^c: $(a^c)")
(a^c).x == b
