import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


x=["eng","hindi","marathi"]
y=[70,80,90]
plt.plot(x,y,color="r")
plt.title("Marks of Subject")
plt.savefig("sales_plot.png")
plt.show()
### Sales Plot:

![Sales Plot](sales_plot.png)


x=["eng","hindi","marathi"]
y=[70,80,90]
plt.bar(x,y,color="r")
plt.title("Marks of Subject")
plt.show()




