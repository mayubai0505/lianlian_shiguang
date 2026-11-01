'use strict';

function parseRoleCommands(userInput, activeCharacters, currentFocusCharacter, charactersList) {
    if (!userInput) return { activeCharacters, currentFocusCharacter };

    const input = userInput.toLowerCase().trim();
    let newActive = [...activeCharacters];
    let newFocus = currentFocusCharacter;

    // 提取所有可能的角色名（從角色卡中抓取）
    const possibleNames = charactersList ?
        charactersList.match(/【([^】]+)】/g)?.map(m => m.replace(/[【】]/g, '').trim()) || [] : [];

    // 1. 召喚角色
    if (/召喚|出來|上場|回來|叫/.test(input)) {
        for (let name of possibleNames) {
            if (input.includes(name.toLowerCase())) {
                if (!newActive.includes(name)) newActive.push(name);
                newFocus = name;
                break;
            }
        }
    }

    // 2. 隱藏/退下角色
    if (/退下|離開|隱藏|別出來|先走|消失/.test(input)) {
        for (let name of possibleNames) {
            if (input.includes(name.toLowerCase())) {
                newActive = newActive.filter(n => n !== name);
                if (newFocus === name && newActive.length > 0) {
                    newFocus = newActive[0];
                }
                break;
            }
        }
    }

    // 3. 專注 / 切換焦點
    if (/專注|只跟|切換到|只看|只和|只想/.test(input)) {
        for (let name of possibleNames) {
            if (input.includes(name.toLowerCase())) {
                newFocus = name;
                if (!newActive.includes(name)) newActive.push(name);
                break;
            }
        }
    }

    // 4. 只留某人
    if (/只留|只剩|只讓/.test(input)) {
        for (let name of possibleNames) {
            if (input.includes(name.toLowerCase())) {
                newActive = [name];
                newFocus = name;
                break;
            }
        }
    }

    // 5. 全員管理
    if (/所有人退下|全員隱藏|大家退下|全部退下/.test(input)) {
        newActive = [newFocus];
    }
    if (/全員上場|大家都在|全部出來|所有人都出來/.test(input)) {
        newActive = possibleNames.length > 0 ? [...possibleNames] : newActive;
    }

    return {
        activeCharacters: newActive,
        currentFocusCharacter: newFocus
    };
}

module.exports = {parseRoleCommands};
