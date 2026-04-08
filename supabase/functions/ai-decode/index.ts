import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

const MINIMAX_API_KEY = Deno.env.get('MINIMAX_API_KEY')
const MINIMAX_API_URL = 'https://api.minimax.chat/v1/text/chatcompletion_v2'

interface DecodeRequest {
  inputText: string
  inputImageUrl?: string
}

serve(async (req) => {
  // CORS headers
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Content-Type': 'application/json',
  }

  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers })
  }

  try {
    const { inputText, inputImageUrl }: DecodeRequest = await req.json()

    if (!inputText || inputText.trim().length < 5) {
      return new Response(
        JSON.stringify({ error: '输入文本太短' }),
        { status: 400, headers }
      )
    }

    if (!MINIMAX_API_KEY) {
      return new Response(
        JSON.stringify({ error: 'API 配置错误' }),
        { status: 500, headers }
      )
    }

    // Build prompt
    const systemPrompt = `你是一位专业的宠物行为分析师，擅长解读宠物的行为、性格和情绪。
请根据用户提供的宠物行为描述，生成一份性格解码报告。

输出格式（JSON）：
{
  "personalityTitle": "性格标题，如：傲娇小霸王",
  "coreAnalysis": "核心性格分析，2-3句话",
  "tags": ["标签1", "标签2", "标签3"],
  "slogan": "一句走心的总结金句"
}

要求：
1. 性格标题要生动有趣，4-6个字
2. 分析要温暖、有洞察力，避免负面评价
3. 标签要精准，3-5个
4. 金句要治愈、有共鸣`;

    const userContent = inputImageUrl
      ? `[图片] ${inputText}`
      : inputText;

    const response = await fetch(MINIMAX_API_KEY, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${MINIMAX_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'abab6.5-chat',
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userContent }
        ],
        temperature: 0.8,
        max_tokens: 800,
      }),
    })

    if (!response.ok) {
      const error = await response.text()
      console.error('MiniMax API error:', error)
      return new Response(
        JSON.stringify({ error: 'AI 服务暂时不可用' }),
        { status: 502, headers }
      )
    }

    const data = await response.json()
    const aiContent = data.choices?.[0]?.message?.content || ''

    // Parse JSON from AI response
    let result
    try {
      // Try to extract JSON from markdown code block or plain text
      const jsonMatch = aiContent.match(/```json\n?([\s\S]*?)\n?```/) || 
                        aiContent.match(/\{[\s\S]*\}/)
      const jsonStr = jsonMatch ? jsonMatch[1] || jsonMatch[0] : aiContent
      result = JSON.parse(jsonStr)
    } catch (e) {
      // Fallback: parse manually
      result = {
        personalityTitle: '神秘小天使',
        coreAnalysis: aiContent.slice(0, 200) || '你的宠物有着独特的个性魅力',
        tags: ['可爱', '独特', '治愈'],
        slogan: '每一个毛孩子都是独一无二的存在 ✨'
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        data: result,
        raw: aiContent,
      }),
      { headers }
    )

  } catch (error) {
    console.error('Error:', error)
    return new Response(
      JSON.stringify({ error: '服务器内部错误' }),
      { status: 500, headers }
    )
  }
})
