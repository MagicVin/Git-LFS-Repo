<a herf="https://about.gitlab.com/2017/01/30/getting-started-with-git-lfs-tutorial/"><h1>原文<h1></a>
<h2>1.Git从Git LFS开始<h2>
<p>	它以最好的意图发生：您的设计团队将他们的大型图形文件添加到您的项目存储库中 - 您可以看到它增长并增长，直到它成为一个多G字节的集群
	在Git中使用大型二进制文件确实很棘手。 每次100 MB Photoshop文件中的微小更改都会被提交，您的存储库将再增加100 MB。 这很快就加起来了，由于其庞大的尺寸，使您的存储库几乎不可用。
	但是，当然，没有使用版本控制来设计/概念/电影/音频/可执行文件/ <other-large-file-use-case>工作不能成为解决方案。 版本控制的一般好处仍然适用，应该在各种项目中获得。
	幸运的是，有一个Git扩展，使大型文件的工作效率更高：对“大文件存储”（或简称“LFS”，如果你喜欢昵称）打个招呼。</p>
<h2>2.没有LFS：膨胀的存储库</h2>
	在我们看看LFS如何运作奇迹之前，我们将仔细研究一下实际的问题。我们以简单的网站项目为例：
	https://about.gitlab.com/images/blogimages/getting-started-with-git-lfs-tutorial/project-setup-without-big-files.png 
	没什么特别的:一些HTML，CSS和JS文件以及一些小图像资源。 不过，到目前为止，我们还没有包括我们的设计资产（Photoshop，Sketch等）。 将您的设计资产置于版本控制之下也是很有意义的。
	https://about.gitlab.com/images/blogimages/getting-started-with-git-lfs-tutorial/project-setup-with-big-files.png

	<h4>但是，这是一个catch：每当我们的设计师对这个新的Photoshop文件做出改变（无论多么小）时，她将向存储库再提交一百MB。 很快，存储库将重达千兆字节和很快的千兆字节，这使得克隆和管理非常繁琐。

	虽然我只是谈到“设计”文件，但这真的是所有“大”文件的问题：电影，录音，数据集等。

<h2>3.使用LFS：高效的大文件处理</h2> 
	当然，LFS不能简单地“消除”所有的大数据：它随着每一个变化而累积，必须被保存。 然而，它将这种负担转移到远程服务器 - 允许本地存储库保持相对精简！

	为了实现这一点，LFS使用一个简单的技巧：它不会将所有文件的版本保留在本地存储库中。 相反，它只提供在检出版本中必要的文件。

	但是这提出了一个有趣的问题：如果这些巨大的文件本身不存在于你的本地存储库...什么是现在？ LFS保存轻量级指针代替真实的文件数据。 当您使用这样的指针检查修订版本时，LFS只需查找原始文件（可能在服务器上，如果它不在自己的特殊缓存中），并为您下载。

	因此，您只能得到您真正想要的文件，而不是您可能永远不需要的一大堆多余的数据。
<h2>4.安装LFS</h2>
<p>LFS不是核心Git二进制文件的一部分，但它可作为扩展。 这意味着，在我们可以使用LFS之前，我们需要确保安装。</p>
<h4>服务器</h4>
	<p>并非所有代码托管服务都支持LFS。 然而，作为GitLab用户，没有什么可担心的：如果您使用GitLab.com或最近版本的GitLab CE或EE，则对LFS的支持已经被烘烤了！ 您的管理员只需要启用LFS选项。</p>

<h4>本地机</h4>
	<p>您当地的Git安装也需要支持LFS。 如果您正在使用Tower，Git桌面客户端，则无需安装任何内容：Tower支持Git Large File System（开箱即用）。

	<p>如果您在命令行中使用Git，则可以使用不同的安装选项：
	 二进制包：最新的二进制包可用于Windows，Mac，Linux和FreeBSD。
     Linux：可从PackageCloud获得Debian和RPM软件包。
     macOS：您可以通过“brew install git-lfs”或MacPorts通过“port install git-lfs”使用Homebrew。
     Windows：您可以通过“choco install git-lfs”使用Chocolatey包管理器。</p>
	
	<p>在您的包管理器完成工作后，您需要使用“lfs install”命令完成安装：
		git lfs install
	</p>
</p>

<h2>使用LFS跟踪文件</h2>
	<p>没有进一步的说明，LFS将不会处理您的大文件问题。 我们必须明确告诉LFS应该处理哪些文件！</p>
	<p>所以让我们回到我们的“大Photoshop文件”的例子。 我们可以指示LFS使用“lfs track”命令来处理“design.psd”文件：
		git lfs track "design-resources/design.psd"</p>

	<p> 乍一看，这个命令似乎没有太大的影响。 但是，您会注意到，项目根文件夹中的新文件已创建（或已更改，如果已存在）：.gitattributes收集我们选择通过LFS进行跟踪的所有文件模式。 我们来看看它的内容：	
		cat .gitattributes 
		design-resources/design.psd filter=lfs diff=lfs merge=lfs -text</p>
	
	<p> 完美！ 从现在开始，LFS将处理此文件。 我们现在可以按照我们习惯的方式将其添加到存储库中。 请注意，对.gitattributes的任何更改也必须提交到存储库，就像其他修改一样：
		git add .gitattributes
		git add design-resources/design.psd
		git commit -m "Add design file"</p>

<h2>跟踪文件模式</h2>
	<p>添加这样一个特定的单个文件是很好的，但是如果要跟踪我们项目中的每个.indd文件，该怎么办？ 请放心：您不必手动添加每个文件！ LFS允许您定义文件模式，就像忽略文件一样。 例如，以下命令将指示LFS跟踪所有InDesign文件 - 现有的和未来的文件：
		git lfs track "*.indd"</p>

	<p>你也可以告诉LFS跟踪整个目录的内容：
		git lfs track "design-assets/*"</p>

<h2>获取跟踪文件概述</h2>
	<p>在某些时候，您可能想知道目前LFS跟踪哪些文件。 你可以简单的看看.gitattributes文件。 然而，这些不是实际的文件，而只是规则，因此高度“理论”：个别文件可能已经滑过，例如。 由于打字错误或过度限制的规则。
	要查看您当前正在跟踪的实际文件的列表，只需使用git lfs ls-files命令：
	
		git lfs ls-files
		194dcdb603 * design-resources/design.psd</p>

<h2>跟踪尽可能的早</h2>
	<p> 请记住，LFS不会改变自然规律：提交到存储库的事情在那里停留。 更改项目的提交历史是非常困难的（而且是危险的）。</p>
	
	<p>这意味着您应该告诉LFS在提交到存储库之前跟踪文件。</p>
	
	<p>否则，它已经成为您项目历史的一部分 - 包括所有的兆字节和千兆字节...
	<br>初始化存储库（就像忽略文件）一样，配置要跟踪哪些文件模式的理想时刻是正确的。</br></p>

<h2>在GUI中使用LFS</h2>

	<p>虽然LFS不难使用，但仍有命令需要记住和事情搞砸。如果你希望使用Git（和LFS）更有效率，请查看Tower，这是用于Mac和Windows的Git桌面客户端。 由于Tower内置了对Git LFS的支持，因此无需安装。 该应用程序已经存在了好几年，并被全球超过8万名用户信赖。</p>
	
	<p> 此外，Tower提供与GitLab的直接集成！ 在塔中连接您的GitLab帐户后，只需单击鼠标即可克隆和创建存储库。</p>

<h2>用Git工作</h2>
	<p>LFS的一个重要方面是，您可以保持正常的Git工作流程：分段，提交，推送，拉动以及其他一切工作原理。 除了我们讨论过的命令外，没有什么值得注意的。</p>
	<p>当您需要时，LFS将提供您需要的文件。</p>
	<p>如果您正在寻找有关LFS的更多信息，请查看此免费在线图书。 有关Git的一般见解，请查看Git Tips＆Tricks博客文章和Tower的视频系列。</p>

<h2>关于访客作者</h2>
	<p>这是由TobiasGünther撰写的客座讲话，他是Tower Git客户背后的团队的一部分。</p>
	<p>封面图片：Git LFS的屏幕截图</p>
