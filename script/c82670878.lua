--血涙のオーガ
function c82670878.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82670878,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c82670878.condition)
	e1:SetTarget(c82670878.target)
	e1:SetOperation(c82670878.operation)
	c:RegisterEffect(e1)
	if not c82670878.global_check then
		c82670878.global_check=true
		c82670878[0]=0
		c82670878[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetCondition(c82670878.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ATTACK_DISABLED)
		ge2:SetCondition(c82670878.check2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c82670878.clear)
		Duel.RegisterEffect(ge3,0)
	end
end
function c82670878.check(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if Duel.GetAttackTarget()==nil then
		c82670878[1-tc:GetControler()]=c82670878[1-tc:GetControler()]+1
		if c82670878[1-tc:GetControler()]==1 then
			c82670878[2]=Duel.GetAttacker()
			c82670878[3]=Duel.GetAttacker():GetAttack()
			c82670878[4]=Duel.GetAttacker():GetDefence()
			Duel.GetAttacker():RegisterFlagEffect(82670878,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c82670878.check2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetFlagEffect(82670878)~=0 and Duel.GetAttackTarget()~=nil then
		c82670878[1-tc:GetControler()]=c82670878[1-tc:GetControler()]-1
	end
end
function c82670878.clear(e,tp,eg,ep,ev,re,r,rp)
	c82670878[0]=0
	c82670878[1]=0
end
function c82670878.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetAttackTarget()==nil and c82670878[tp]==2
end
function c82670878.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.ConfirmCards(1-tp,c)
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c82670878.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		if c82670878[2] and c82670878[2]:GetFlagEffect(82670878) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			e1:SetValue(c82670878[3])
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENCE)
			e2:SetValue(c82670878[4])
			c:RegisterEffect(e2)
			--at limit
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetRange(LOCATION_MZONE)
			e3:SetTargetRange(LOCATION_MZONE,0)
			e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
			e3:SetTarget(c82670878.atlimit)
			e3:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e3)
		end
		Duel.SpecialSummonComplete()
	end
end
function c82670878.atlimit(e,c)
	return c~=e:GetHandler()
end
