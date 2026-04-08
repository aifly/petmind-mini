import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

const MINIMAX_API_KEY = Deno.env.get('MINIMAX_API_KEY')

interface HealthRequest {
  petType: 'cat' | 'dog' | 'other'
  symptomText: string
}

serve(async (req) => {
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Content-Type': 'application/json',
  }

  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers })
  }

  try {
    const { petType, symptomText }: HealthRequest = await req.json()

    if (!symptomText || symptomText.trim().length < 5) {
      return new Response(
        JSON.stringify({ error: '症状描述太短' }),
        { status: 400, headers }
      )
    }

    if (!MINIMAX_API_KEY) {
      return new Response(
        JSON.stringify({ error: 'API 配置错误' }),
        { status: 500, headers }
      )
    }

    const petTypeText = petType === 'cat' ? '猫' : petType === 'dog' ? '狗' : '宠物'

    const systemPrompt = `你是一位专业的宠物健康顾问，擅长初步分析宠物症状并提供建议。
请根据用户描述的${petTypeText}症状，生成一份健康分析报告。

输出格式（JSON）：
{
  "urgency": "low|medium|high",
  "causes": [
    { "name": "可能原因1", "desc": "简要说明" },
    { "name": "可能原因2", "desc": "简要说明" },
    { "name": "可能原因3", "desc": "简要说明" }
  ],
  "advice": ["建议1", "建议2", "建议3", "建议4"],
  "comfort": "一句安慰铲屎官的温暖话语"
}

紧急度判断：
- low: 轻微症状，可先观察
- medium: 需要关注，建议咨询兽医
- high: 严重症状，建议尽快就医

要求：
1. 分析要专业但易懂
2. 必须强调这只是参考建议，不能替代兽医诊断
3. 紧急情况要明确建议就医
4. 安慰话语要温暖有同理心`;

    const response = await fetch('https://api.minimax.chat/v1/text/chatcompletion_v2', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${MINIMAX_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'abab6.5-chat',
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: symptomText }
        ],
        temperature: 0.7,
        max_tokens: 1000,
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

    let result
    try {
      const jsonMatch = aiContent.match(/```json\n?([\s\S]*?)\n?```/) || 
                        aiContent.match(/\{[\s\S]*\}/)
      const jsonStr = jsonMatch ? jsonMatch[1] || jsonMatch[0] : aiContent
      result = JSON.parse(jsonStr)
    } catch (e) {
      result = {
        urgency: 'medium',
        causes: [
          { name: '需要进一步观察', desc: '根据描述无法确定具体原因' }
        ],
        advice: ['建议咨询专业兽医', '记录症状变化', '保持观察'],
        comfort: '别太担心，及时就医是最好的选择。你的毛孩子能感受到你的关爱 💙'
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
