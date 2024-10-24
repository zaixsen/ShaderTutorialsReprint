Shader "Reprint/003_transparency"
{
   Properties
   {
		_Color("Color",Color)=(1,1,1,1)
		_MainTex("Main Tex",2D)="write" {}  
   }

   SubShader
   {
	   Tags{"RenderType"= "Transparent" "Queue"="Transparent"}

	   Blend SrcAlpha OneMinusSrcAlpha  ///源颜色 x 源通道  +  目标颜色 x（1 - 源通道）  常用的混合模式
		//ZWrite off
	
	   Pass
	   {
		   CGPROGRAM
				#include "UnityCG.cginc"

				#pragma vertex vert
				#pragma fragment frag

				sampler _MainTex;
				float4 _MainTex_ST;
				fixed4 _Color;

				struct appdata
				{
					float4 vertex:POSITION;
					float2 uv:TEXCOORD0;	
				};

				struct v2f
				{
					float4 vertex:SV_POSITION;
					float2 uv:TEXCOORD0;
				};

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex=UnityObjectToClipPos(v.vertex);
					o.uv=TRANSFORM_TEX(v.uv,_MainTex);

					return o;
				}

				fixed4 frag(v2f v) : SV_TARGET
				{
					fixed4 col = tex2D(_MainTex,v.uv) *_Color;
					return col;
				}
		   ENDCG
	   }

   }
}
