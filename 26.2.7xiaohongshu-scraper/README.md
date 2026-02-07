# 🦞 xiaohongshu-scraper

OpenClaw 小红书抓取技能包 — 在钉钉/Telegram/WhatsApp 中发送小红书链接，自动抓取内容、AI 生成摘要、保存到 Obsidian。

## 工作流

```
发送小红书链接 → Jina Reader 抓取（失败则 web_fetch 兜底） → AI 分析生成摘要 → 保存到 Obsidian vault
```

## 前提条件

- [OpenClaw](https://github.com/openclaw/openclaw) 已安装并运行
- Node.js 18+
- 已配置至少一个消息渠道（钉钉/Telegram/WhatsApp 等）

## 安装

### 方式一：自动安装（推荐）

```bash
# 克隆仓库
git clone https://github.com/adoresever/AGI_Ananans.git
cd AGI_Ananans/26.2.7xiaohongshu-scraper

# 运行安装脚本
chmod +x install.sh
./install.sh
```

安装脚本会自动：
- 检测 OpenClaw workspace 路径和 npx 路径
- 创建 Obsidian vault 目录（默认 `~/xiaohongshu-notes`）
- 生成适配你环境的 SKILL.md 并安装到 workspace/skills

### 方式二：手动安装

1. 将 `SKILL.md.template` 复制到 `~/.openclaw/workspace/skills/xiaohongshu-scraper/SKILL.md`
2. 替换其中的占位符（详见模板文件中的注释）
3. 创建保存目录：`mkdir -p ~/xiaohongshu-notes`

## 配置 Jina API Key

Jina Reader 是首选抓取工具，将网页转为干净的 Markdown 格式。**免费额度足够个人使用。**

### 第一步：获取 API Key

前往 https://jina.ai/reader 免费注册，获取 API Key。

### 第二步：写入 mcporter.json

编辑 `~/.openclaw/workspace/config/mcporter.json`（如果文件或目录不存在则创建）：

```json
{
  "mcpServers": {
    "jina": {
      "baseUrl": "https://mcp.jina.ai/v1",
      "headers": {
        "Authorization": "Bearer 你的_jina_api_key"
      }
    }
  }
}
```

### 第三步：验证连接

```bash
npx mcporter list --config ~/.openclaw/workspace/config/mcporter.json
```

看到 `jina (20 tools)` 且状态 healthy 即配置成功。

### 第四步：重启 Gateway

```bash
openclaw gateway restart
# 或根据你的安装方式：
# cd ~/openclaw && pnpm openclaw gateway restart
# systemctl --user restart openclaw-gateway.service
```

## 使用

在你的消息平台中给 OpenClaw 发送：

```
抓取这个小红书笔记并保存到Obsidian：https://www.xiaohongshu.com/explore/xxxxxx
```

OpenClaw 会自动：
1. 调用 Jina Reader 将页面转为 Markdown（失败时用 web_fetch 兜底）
2. AI 分析内容，提取标题、作者、标签
3. 生成摘要和关键观点
4. 保存为结构化 Markdown 到 Obsidian vault

### 批量抓取

```
请依次抓取以下小红书链接并保存到Obsidian：
1. https://www.xiaohongshu.com/explore/xxx1
2. https://www.xiaohongshu.com/explore/xxx2
```

## 保存格式示例

抓取后的笔记格式（见 [examples/sample_note.md](examples/sample_note.md)）：

```markdown
---
source: https://www.xiaohongshu.com/explore/...
author: 小红书用户
date: 2026-02-07
tags:
  - 标签1
  - 标签2
---

# 标题

## 摘要
（AI 生成的内容摘要）

## 关键观点
（3-5 个核心要点）

## 原文内容
（完整正文）
```

## 抓取策略

| 层级 | 工具 | 说明 |
|------|------|------|
| 首选 | Jina Reader（MCP） | 输出干净 Markdown，质量最高 |
| 兜底 | web_fetch（内置） | OpenClaw 内置工具，稳定可靠 |

为什么不用 Puppeteer 兜底？实测中 web_fetch 作为 OpenClaw 内置工具，稳定性优于 Puppeteer（尤其在国内网络环境下）。

## 常见问题

### Jina 抓取失败

- 确认 API Key 配置正确
- 确认 `mcporter.json` 路径无误
- 运行 `npx mcporter list --config ~/.openclaw/workspace/config/mcporter.json` 检查连接状态
- Jina 失败时 agent 会自动切换 web_fetch，不影响使用

### 文件没有保存

- 确认 Obsidian vault 目录存在且有写入权限
- 检查 SKILL.md 中的保存路径是否正确

### Agent 没有调用 Jina

- 确认 SKILL.md 已安装到 `~/.openclaw/workspace/skills/xiaohongshu-scraper/`
- 确认 SKILL.md 中的 npx 路径与你系统一致（运行 `which npx` 查看）
- 尝试在消息中明确提到"小红书"触发技能

## 致谢

- [Jina AI](https://jina.ai/) — 提供网页转 Markdown 的 MCP 服务
- [OpenClaw](https://github.com/openclaw/openclaw) — 开源 AI Agent 平台
- [mcporter](https://github.com/steipete/mcporter) — MCP 服务器管理工具
