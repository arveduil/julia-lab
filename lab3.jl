function make_strings(n)
    for i = 1:n
        s = Base.Random.randstring(Base.Random.GLOBAL_RNG, 17)
    end
end

function fun_long()
    make_strings(100000)
end

function fun_short()
    make_strings(10000)
end

function main()
    j = 0
    while (j < 500)
        fun_long()
        fun_short()
        j += 1
    end
end

main() #compilation
Profile.clear() #clearing profiler
#Profile.init(n = 10^7, delay = 0.1) #setting n and delay
#Profile.init(n = 10^7, delay = 0.000000000000001) #for this value of delay, program is running for around 2 minutes
Profile.init()
@profile main()
#Profile.print() #print in tree form
#Profile.print(format=:flat) # print in normal form
using ProfileView
ProfileView.view() # print in graphic
