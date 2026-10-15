-- Execute the real callback in an isolated Lua environment with fixture lists.
local env={EEex_Utility_IterateCPtrList=function(list,fn) for _,effect in ipairs(list) do fn(effect) end end,
    EEex_Resource_KitIDSToSymbol=function(kit) return ({[0x402A]='C0EK',[0x402B]='C0EK_SORC',[0x4000]='TRUECLASS'})[kit] end,
    print=function() end}
setmetatable(env,{__index=_G})
local callbackPath=(arg and arg[1]) or 'ArtisansKitpack/eeex/M_EKCF.lua'
local chunk=assert(loadfile(callbackPath))
setfenv(chunk,env);chunk()
local function res(text) return {get=function() return text end} end
local function fixture(options)
    options=options or {}
    local restriction={m_effectId=options.op or 177,m_durationType=2,m_effectAmount=0,m_dWFlags=2,
        m_sourceType=options.sourceType or 2,m_res=res(options.restriction or 'C0ARCAS2'),m_done=0}
    local actor={m_id=1,m_baseStats={m_mageSpecUpperWord=0,m_mageSpecialization=options.kit or 0x402B},
        m_timedEffectList={},m_equipedEffectList={restriction}}
    if options.image~=false then actor.m_timedEffectList[#actor.m_timedEffectList+1]={m_effectId=237,m_dWFlags=options.imageType or 2} end
    if options.protected~=false then actor.m_timedEffectList[#actor.m_timedEffectList+1]={m_effectId=318,
        m_durationType=options.protectionTiming or 9,m_effectAmount=options.condition or 0,m_dWFlags=0,
        m_res=res(options.protection or 'C0ARCAS2')} end
    return actor,restriction
end
local cases={
    {{},1},
    {{imageType=3},1},
    {{kit=0x402A},1},
    {{kit=0x4000},0},
    {{image=false},0},
    {{imageType=1},0},
    {{protected=false},0},
    {{protection='C0ARCAS1'},0},
    {{protection='C0ARCAS1',restriction='C0ARCAS1'},1},
    {{restriction='OTHER'},0},
    {{op=145},0},
    {{sourceType=1},0},
    {{protectionTiming=0},0},
    {{condition=1},0},
    {{restriction='c0arcas2'},1},
}
for index,case in ipairs(cases) do
    local actor,effect=fixture(case[1])
    env.EKCLNFIX({},actor)
    assert(effect.m_done==case[2],'guard regression '..index)
end
env.EKCLNFIX({},nil)
print('PASS: '..#cases..' callback guard cases; nil sprite safe')
return {policyCases=#cases,nilSpriteSafe=true,engineCalls=0,status='PASS'}
