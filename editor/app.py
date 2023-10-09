#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   app.py
@Describe :  
@Contact :   mrbingzhao@qq.com
@License :   (C)Copyright 2023/7/6, Liugroup-NLPR-CASIA

@Modify Time        @Author       @Version    @Desciption
----------------   -----------   ---------    -----------
2023/7/6 上午10:56   liubingzhao      1.0           ml
'''
import gradio as gr

# 定义模型函数，例如，一个简单的文本分类器
def text_classifier(text):
    # 在此处添加你的文本分类代码
    # 下面是一个简单的例子，它只是返回传入的文本
    return text

# 创建一个Gradio接口，传入模型函数和输入类型。
# 注意：这里我们使用'html'作为输入类型，它将渲染一个富文本编辑器。
iface = gr.Interface(fn=text_classifier, inputs="html", outputs="text")

# 启动Gradio接口
iface.launch()
