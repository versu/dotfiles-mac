hs.autoLaunch(true)

-- Finder の操作を Windows のエクスプローラーに寄せる
-- Finder で フォルダ選択中にEnter を押すと名前の変更になるが、これをWindowsと同様に開く動作に変更する。

local FINDER_BUNDLE_ID = "com.apple.finder"

-- 文字入力中の Enter（名前の変更・検索欄など）は横取りしない
local TEXT_INPUT_ROLES = {
  AXTextField = true,
  AXTextArea = true,
  AXSearchField = true,
  AXComboBox = true,
}

-- フォーカスが Finder のファイル一覧（またはデスクトップ）にあるかを判定する。
-- Raycast などのパネルは前面アプリを Finder のままにして開くため、
-- 前面アプリだけでなくフォーカス中の要素の持ち主まで確認する。
local function isFinderFileListFocused()
  local app = hs.application.frontmostApplication()
  if not app or app:bundleID() ~= FINDER_BUNDLE_ID then
    return false
  end

  local focused = hs.axuielement.systemWideElement():attributeValue("AXFocusedUIElement")
  if not focused or focused:pid() ~= app:pid() then
    return false
  end
  if TEXT_INPUT_ROLES[focused:attributeValue("AXRole")] then
    return false
  end

  -- 確認ダイアログやシートでは Enter を既定ボタンの決定に使うため対象外にする。
  -- デスクトップはウィンドウを持たないので、ウィンドウなしは対象に含める。
  local window = focused:attributeValue("AXWindow")
  return window == nil or window:attributeValue("AXSubrole") == "AXStandardWindow"
end

-- Enter で選択中のファイル・フォルダを開く（Finder 標準では名前の変更になる）。
-- テンキー側の Enter は対象外。Karabiner が F2 をテンキー Enter に変換して
-- 名前の変更に使っているため。
-- ガベージコレクションで監視が止まらないよう、グローバルに保持する。
finderEnterToOpen = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  if event:getKeyCode() ~= hs.keycodes.map["return"] or next(event:getFlags()) ~= nil then
    return false
  end
  if not isFinderFileListFocused() then
    return false
  end

  return true, {
    hs.eventtap.event.newKeyEvent({ "cmd" }, "down", true),
    hs.eventtap.event.newKeyEvent({ "cmd" }, "down", false),
  }
end)
finderEnterToOpen:start()
