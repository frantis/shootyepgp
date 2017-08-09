local T = AceLibrary("Tablet-2.0")
local D = AceLibrary("Dewdrop-2.0")
local C = AceLibrary("Crayon-2.0")

local BC = AceLibrary("Babble-Class-2.2")

sepgp_reserves = sepgp:NewModule("sepgp_reserves", "AceDB-2.0")

function sepgp_reserves:OnEnable()
  if not T:IsRegistered("sepgp_reserves") then
    T:Register("sepgp_reserves",
      "children", function()
        T:SetTitle("shootyepgp reserves")
        self:OnTooltipUpdate()
      end,
      "showTitleWhenDetached", true,
      "showHintWhenDetached", true,
      "cantAttach", true,
      "menu", function()
        D:AddLine(
          "text", "Refresh",
          "tooltipText", "Refresh window",
          "func", function() sepgp_reserves:Refresh() end
        )
      end      
    )
  end
  if not T:IsAttached("sepgp_reserves") then
    T:Open("sepgp_reserves")
  end
end

function sepgp_reserves:OnDisable()
  T:Close("sepgp_reserves")
end

function sepgp_reserves:Refresh()
  T:Refresh("sepgp_reserves")
end

function sepgp_reserves:Toggle(forceShow)
  if T:IsAttached("sepgp_reserves") then
    T:Detach("sepgp_reserves")
    if (T:IsLocked("sepgp_reserves")) then
      T:ToggleLocked("sepgp_reserves")
    end
  elseif (forceShow) then
  else
    T:Attach("sepgp_reserves")
  end
end

function sepgp_reserves:OnClickItem(name)
  ChatFrame_SendTell(name)
end

function sepgp_reserves:BuildReservesTable()
  --{name,class,rank,alt}
  table.sort(sepgp.reserves, function(a,b)
    if (a[2] ~= b[2]) then return a[2] > b[2]
    else return a[1] > b[1] end
  end)
  return sepgp.reserves
end

function sepgp_reserves:OnTooltipUpdate()
  local cdcat = T:AddCategory(
      "columns", 2
    )
  cdcat:AddLine(
      "text", C:Orange("Countdown"),
      "text2", sepgp.timer.cd_text
    )
  local cat = T:AddCategory(
      "columns", 3,
      "text",  C:Orange("Name"),   "child_textR",    1, "child_textG",    1, "child_textB",    1, "child_justify",  "LEFT",
      "text2", C:Orange("Rank"),     "child_text2R",   1, "child_text2G",   1, "child_text2B",   0, "child_justify2", "RIGHT",
      "text3", C:Orange("OnAlt"),  "child_text3R",   0, "child_text3G",   1, "child_text3B",   0, "child_justify3", "RIGHT"
    )
  local t = self:BuildReservesTable()
  for i = 1, table.getn(t) do
    local name, class, rank, alt = unpack(t[i])
    cat:AddLine(
      "text", C:Colorize(BC:GetHexColor(class), name),
      "text2", rank,
      "text3", alt or "",
      "func", "OnClickItem", "arg1", self, "arg2", alt or name
    )
  end
end