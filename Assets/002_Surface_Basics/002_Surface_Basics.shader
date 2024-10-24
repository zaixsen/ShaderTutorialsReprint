Shader "Reprint/002_Surface_Basics"
{
    //�α�����ɫ��  https://docs.unity.cn/2021.3/Documentation/Manual/SL-SurfaceShaders.html
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)             
        _MainTex ("Albedo (RGB)", 2D) = "white" {}      //������
        _Glossiness ("Smoothness", Range(0,1)) = 0.5    //�����
        _Metallic ("Metallic", Range(0,1)) = 0.0        //������
        [HDR] _Emssion("Emssion",color) =(0,0,0)        //�Է���
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
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);  //�����UV������
            
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
