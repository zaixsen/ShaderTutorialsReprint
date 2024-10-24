Shader "Reprint/002_Surface_Basics"
{
    //次表面着色器  https://docs.unity.cn/2021.3/Documentation/Manual/SL-SurfaceShaders.html
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)             
        _MainTex ("Albedo (RGB)", 2D) = "white" {}      //主纹理
        _Glossiness ("Smoothness", Range(0,1)) = 0.5    //光泽度
        _Metallic ("Metallic", Range(0,1)) = 0.0        //金属度
        [HDR] _Emssion("Emssion",color) =(0,0,0)        //自发光
    }
    SubShader
    {
        Tags { "RenderType"="Opaque"  "Queue"="Geometry"}
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0
        
        sampler2D _MainTex;
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float3 _Emssion;

        struct Input
        {
            float2 uv_MainTex;
        };


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);  //纹理和UV的设置
            
            c*=_Color;
            o.Albedo=c.rgb;
            o.Emission=_Emssion;
            o.Metallic=_Metallic;
            o.Smoothness=_Glossiness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
