Shader "Reprint/001_Basic"
{
    //属性 可以在面板上设置的 所有类型具体查官方文档 ：https://docs.unity.cn/2021.3/Documentation/Manual/SL-Properties.html
    Properties
    {
        _MainTex("Textrue",2D) = "write" {}
        _Color("Color",Color)=(1,1,1,1)
    }
    //子Shader 根据机型适配不同的subShader  可以有多个  官方文档：https://docs.unity.cn/2021.3/Documentation/Manual/SL-SubShader.html
    SubShader
    {
        //标签 可以设置基本属性 渲染相关的    官方文档：https://docs.unity.cn/2021.3/Documentation/Manual/SL-PassTags.html
        Tags 
        { 
            "RenderType" ="Opaque" 
            "Queue"="Geometry"
        }

        Pass
        {
            CGPROGRAM
            //引用使用的Shader函数
            #include "UnityCG.cginc"

            //定义顶点和片元着色器
            #pragma vertex vert
            #pragma fragment frag

            //接收变量   
            sampler _MainTex;   //采样器
            float4 _MainTex_ST; //_MainTex 的 Tiling & Offset会自动附在这个变量里
            fixed4 _Color;

            struct appdata
            {
                //顶点
                float4 vertex : POSITION;  //用来存储模型在本地坐标下，模型空间中（objcet space）的顶点坐标，转换为剪裁空间坐标前的坐标，unity告诉我们的模型顶点坐标，没经过转换的。可用作定点着色器（vertex shader）的输入、输出；片元着色器（frag）的输入
                float2 uv:TEXCOORD0;
            };

            struct v2f
            {
               float4 position:SV_POSITION; //用来存储模型在剪裁空间，投影空间中的位置信息，即把模型空间的定点坐标，转化为剪裁空间的坐标，可用作定点着色器（vertex shader）的输出；片元着色器（frag）的输入
               float2 uv:TEXCOORED0;
            };

            v2f vert(appdata v)
            {
                //顶点坐标转换
                v2f o;
                //unity物体坐标转为裁剪坐标
                o.position = UnityObjectToClipPos(v.vertex);
                //对UV的比例进行调整
                o.uv = TRANSFORM_TEX(v.uv,_MainTex);  //用 v.uv * _MainTex_ST.xy + _MainTex_ST.zw 实现的效果其实 和 TRANSFORM_TEX(v.uv,_MainTex)实现的效果是一样的
                return o;
            }

            fixed4 frag(v2f o) : SV_TARGET   //SV_TARGET--> 着色器颜色输出的语义
            {
                fixed4 col = tex2D(_MainTex,o.uv);   //每个片源操作 从uv上拿取颜色

                col *=_Color;

                return col;
            }

            ENDCG
        }
    }
    
}

