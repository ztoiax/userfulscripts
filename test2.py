#!/bin/python3
from pyecharts.charts import Line
import pyecharts.options as opts

line = Line()
attr = ["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"]
v1 = [5, 20, 36, 10, 75, 90]
v2 = [10, 25, 8, 60, 20, 80]

(
    Line()
    .add_xaxis(xaxis_data=attr)
    .add_yaxis(series_name="商品A", y_axis=v1,
        markpoint_opts=opts.MarkPointOpts(
            data=[
                opts.MarkPointItem(type_="max", name="最大值"),
                opts.MarkPointItem(type_="min", name="最小值"),
            ]
        ),
        markline_opts=opts.MarkLineOpts(
            data=[opts.MarkLineItem(type_="average", name="平均值")]
        ),
    )
    .add_yaxis(series_name="商品B", y_axis=v2,
        markpoint_opts=opts.MarkPointOpts(
            data=[opts.MarkPointItem(value=-2, name="周最低", x=1, y=-1.5)]
        ),
        markline_opts=opts.MarkLineOpts(
            data=[
                opts.MarkLineItem(type_="average", name="平均值"),
                opts.MarkLineItem(symbol="none", x="90%", y="max"),
                opts.MarkLineItem(symbol="circle", type_="max", name="最高点"),
            ]
        ),
    )
    # 图表转换
    .set_global_opts(
        title_opts=opts.TitleOpts(title="标题", subtitle="子标题"),
        tooltip_opts=opts.TooltipOpts(trigger="axis"),
        toolbox_opts=opts.ToolboxOpts(is_show=True),
        xaxis_opts=opts.AxisOpts(type_="category", boundary_gap=False),
    )
    .render("name.html")
)
