Shader "Reprint/001_Basic"
{
    //���� ��������������õ� �������;����ٷ��ĵ� ��https://docs.unity.cn/2021.3/Documentation/Manual/SL-Properties.html
    Properties
    {
        _MainTex("Textrue",2D) = "write" {}
        _Color("Color",Color)=(1,1,1,1)
    }
    //��Shader ���ݻ������䲻ͬ��subShader  �����ж��  �ٷ��ĵ���https://docs.unity.cn/2021.3/Documentation/Manual/SL-SubShader.html
    SubShader
    {
        //��ǩ �������û������� ��Ⱦ��ص�    �ٷ��ĵ���https://docs.unity.cn/2021.3/Documentation/Manual/SL-PassTags.html
        Tags 
        { 
            "RenderType" ="Opaque" 
            "Queue"="Geometry"
        }

        Pass
        {
            CGPROGRAM
            //����ʹ�õ�Shader����
            #include "UnityCG.cginc"

            //���嶥���ƬԪ��ɫ��
            #pragma vertex vert
            #pragma fragment frag

            //���ձ���   
            sampler _MainTex;   //������
            float4 _MainTex_ST; //_MainTex �� Tiling & Offset���Զ��������������
            fixed4 _Color;

            struct appdata
            {
                //����
                float4 vertex : POSITION;  //�����洢ģ���ڱ��������£�ģ�Ϳռ��У�objcet space���Ķ������꣬ת��Ϊ���ÿռ�����ǰ�����꣬unity�������ǵ�ģ�Ͷ������꣬û����ת���ġ�������������ɫ����vertex shader�������롢�����ƬԪ��ɫ����frag��������
                float2 uv:TEXCOORD0;
            };

            struct v2f
            {
               float4 position:SV_POSITION; //�����洢ģ���ڼ��ÿռ䣬ͶӰ�ռ��е�λ����Ϣ������ģ�Ϳռ�Ķ������꣬ת��Ϊ���ÿռ�����꣬������������ɫ����vertex shader���������ƬԪ��ɫ����frag��������
               float2 uv:TEXCOORED0;
            };

            v2f vert(appdata v)
            {
                //��������ת��
                v2f o;
                //unity��������תΪ�ü�����
                o.position = UnityObjectToClipPos(v.vertex);
                //��UV�ı������е���
                o.uv = TRANSFORM_TEX(v.uv,_MainTex);  //�� v.uv * _MainTex_ST.xy + _MainTex_ST.zw ʵ�ֵ�Ч����ʵ �� TRANSFORM_TEX(v.uv,_MainTex)ʵ�ֵ�Ч����һ����
                return o;
            }

            fixed4 frag(v2f o) : SV_TARGET   //SV_TARGET--> ��ɫ����ɫ���������
            {
                fixed4 col = tex2D(_MainTex,o.uv);   //ÿ��ƬԴ���� ��uv����ȡ��ɫ

                col *=_Color;

                return col;
            }

            ENDCG
        }
    }
    
}

