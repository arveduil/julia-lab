#Piotr Boszczyk
using  Gadfly
using  DataFrames
using DifferentialEquations

fuu = @ode_def LotkaVolterraExample begin
    dx = a1*x - b1*x*y
    dy = -c1*y + d1*x*y
end a1 b1 c1 d1
function lv(a=1.5,b=1,c=3,d=1,x0=6.0, y0=4.0)
    u0lv= [x0,y0]
    p=[a,b,c,d]
    u0=8.0
    tspan = (0.0 , 15.0)

    prob = ODEProblem(fuu,u0lv,tspan,p)
    sol = solve(prob,RK4(),dt=0.01 )

    fieldnames(sol)
    title = string(string(a),",",string(b),",",string(c),",",string(d))
    df1=DataFrame(t=sol.t, xy =sol.u, exp = title)


    df2=hcat(df1, collect(1:size(df1,1)))
    df2[:x1] = map((x,y) -> y[2] - x[1], df2[:xy] , df2[:xy])
    rename!(df2,:x1,:diff)
    df3=hcat(df2, collect(1:size(df2,1)))
    rename!(df3,:x1, :y)

    df3[:y] = map((x) ->  x[2], df3[:xy])
    df3[:xy] = map((x) ->  x[1], df3[:xy])
    rename!(df3,:xy, :x)
    writetable(string(title,".csv"), df3)

    pred= df3[:y]
    prey= df3[:x]
    print("Minimum prey= ",minimum(prey),"\n")
    print("Maximum prey= ",maximum(prey),"\n")
    print("Mean prey= ",mean(prey),"\n")
    print("Minimum predators= ",minimum(pred),"\n")
    print("Maximum predators= ",maximum(pred),"\n")
    print("Mean predators= ",mean(pred),"\n")
    df3
end

lvdf = Array{DataFrame}(4)

lvdf[1] = lv(1.5 , 1 , 3 , 1 , 6.0 , 4.0)
lvdf[2] = lv(1,1,1,1, 8.0,3.0)
lvdf[3] = lv(5,1,2,1.5, 6.0 , 4.0)
lvdf[4] = lv(10,2,4,2,6.0,4.0)

dfArr = lvdf[1]
for i = 2:4
    dfArr=[dfArr; lvdf[i]]
end

dark_panel = Theme(
    panel_fill="black",
    default_color="orange",
    point_size=0.015cm
    )

Gadfly.push_theme(dark_panel)
set_default_plot_size(40cm, 15cm)
#phase plot
plot(dfArr, x="x", y="y", color = "exp",Geom.polygon)
#all plots
plot(dfArr,  x="t", y=Col.value(:x, :y ),ygroup="exp"  , color= "diff",
  Geom.subplot_grid(Geom.path))
