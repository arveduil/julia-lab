
function bubbleSort(t)
    for j=1:(length(t)-1)
        for i= j:(length(t)-1)
            if  t[i]>t[i+1]
                tmp = t[i]
                t[i]=t[i+1]
                t[i+1]=tmp
            end
        end
    end
end


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
