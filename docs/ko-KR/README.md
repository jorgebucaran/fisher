[slack-link]: https://fisherman-wharf.herokuapp.com
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[organization]: https://github.com/fisherman
[fish]: https://github.com/fish-shell/fish-shell
[fisherman]: http://fisherman.sh
[online]: http://fisherman.sh/#search

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman]

fisherman은 [fish]을 위한 병렬 처리 플러그인 매니저 입니다.

## 왜 fisherman을 사용해야 하죠?

* 설정 없음

* 의존성 없음

* Shell 시작 시간에 영향 없음

* 설치, 업데이트, 제거, 목록, 도움말의 필수 기능에 집중

* 커멘드라인을 통한 인터렉티브 관리 혹은 플러그인 패키지 파일로 부터 일괄 관리 지원

## 설치

curl를 통한 설치:

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
```

## 사용법

플러그인 설치:

```
fisher sol 
```

여러 출처로 부터 한꺼번에 설치:

```
fisher z fzf edc/bass omf/thefuck
```

URL를 통해 설치:

```
fisher https://github.com/edc/bass
```

gist로 부터 설치:

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

로컬 디렉토리로 부터 설치:

```sh
fisher ~/plugin
```

플러그인 패키지 관리 파일로 정의하고 `fisher` 명령어로 변경사항을 적용:

> [fishfile이 뭐죠? 어떻게 사용하나요?](#6-fishfile이-뭐죠?-어떻게-사용하나요?)

```sh
$EDITOR fishfile # 플러그인 추가
fisher
```

설치된 플러그인 확인:

```ApacheConf
fisher ls
@ plugin      # 로컬 디렉토리 설치 플러그인
* sol         # 현재 사용되고 있는 프롬프트 스타일 플러그인
  bass
  fzf
  grc
  thefuck
  z
```

모두 업데이트:

```
fisher up
```

일부 업데이트:

```
fisher up bass z fzf thefuck
```

플러그인 삭제:

```
fisher rm thefuck
```

모든 플러그인 삭제:

```
fisher ls | fisher rm
```

도움말 보기:

```
fisher help z
```

## 자주묻는 질문과 답변

### 필요로하는 fish shell 버전은?

fisherman은 fish shell 버전 2.3.0 이상부터 지원합니다. 만약 2.2.0을 사용하고 있다면 [코드조각](#8-플러그인이-뭐죠?) 지원을 위하여 아래의 코드를 `~/.config/fish/config.fish`에 추가해 주세요.

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### 어떻게 fish를 기본 shell로 지정하나요?

*/etc/shells* 파일에 있는 shell 목록에 fish를 추가하고, 기본 shell로 지정합니다.

```sh
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```

### fisherman을 삭제하고 싶어요.

```fish
fisher self-uninstall
```

혹은

```
npm un -g fisherman
```

### fisherman은 oh my fish 패키지 관리자의 테마, 플러그인과 호환 되나요?

네.

### fisherman은 어디에 파일을 두나요?

fisherman 자체는 *~/.config/fish/functions/fisher.fish* 입니다.

캐쉬와 플러그인 관리 파일은 각각 *~/.cache/fisherman* 과 *~/.config/fisherman* 을 관례로 사용합니다.

fishfile은 *~/.config/fish/fishfile* 에 위치합니다.

### fishfile이 뭐죠? 어떻게 사용하나요?

fishfile은 *~/.config/fish/fishfile* 위치하며 모든 설치 플러그인의 목록이 담겨있습니다.

fisherman 명령어를 통해 플러그인을 설치/제거하면 자동으로 fishfile이 관리됩니다. 혹은, fishfile에 직접 플러그인을 추가하고 `fisher` 명령어를 입력하면 변경사항이 적용됩니다.

```
fisherman/sol 
fisherman/z
omf/thefuck
omf/grc
```

이 방식은 설치나 이가 빠진 의존성에만 작동 합니다. 플러그인을 삭제하려면, `fisher rm`명령어를 사용하세요.

### 어디서 플러그인을 찾을 수 있나요?

fisherman의 [organization] 페이지를 살펴보거나 [online] 플러그인 목록에서 찾아보세요.

### 플러그인이 뭐죠?

플러그인은:

1. 최상단 혹은 최상단에 위치한 *functions* 디렉토리에 담긴 *.fish* 파일이 기능으로 작동하는 디렉토리 혹은 git 저장소

2. 테마 혹은 프롬프트. 예: *fish_prompt.fish* 이거나 *fish_right_prompt.fish* 혹은 두 파일 전부

3. 코드 조각. 예: fish shell 시작시 불러들이게 되는 *conf.d* 디렉토리 안에 위치 한 *.fish* 파일들

### 플러그인 제작시 의존성을 명시하는 방법이 있나요?

작성하는 플러그인 최상단 디렉토리에  *fishfile* 를 만들고 의존성을 나열하세요.

```fish
owner/repo
https://github.com/owner/repo
https://gist.github.com/owner/c256586044fea832e62f02bc6f6daf32
```
