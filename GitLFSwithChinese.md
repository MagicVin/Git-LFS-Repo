
<h2>原文
https://about.gitlab.com/2017/01/30/getting-started-with-git-lfs-tutorial/
<h2>Git从Git LFS开始
	它以最好的意图发生：您的设计团队将他们的大型图形文件添加到您的项目存储库中 - 您可以看到它增长并增长，直到它成为一个多G字节的集群
	在Git中使用大型二进制文件确实很棘手。 每次100 MB Photoshop文件中的微小更改都会被提交，您的存储库将再增加100 MB。 这很快就加起来了，由于其庞大的尺寸，使您的存储库几乎不可用。
	但是，当然，没有使用版本控制来设计/概念/电影/音频/可执行文件/ <other-large-file-use-case>工作不能成为解决方案。 版本控制的一般好处仍然适用，应该在各种项目中获得。
	幸运的是，有一个Git扩展，使大型文件的工作效率更高：对“大文件存储”（或简称“LFS”，如果你喜欢昵称）打个招呼。
<h2>没有LFS：膨胀的存储库
	在我们看看LFS如何运作奇迹之前，我们将仔细研究一下实际的问题。我们以简单的网站项目为例：
	https://about.gitlab.com/images/blogimages/getting-started-with-git-lfs-tutorial/project-setup-without-big-files.png 
	没什么特别的:一些HTML，CSS和JS文件以及一些小图像资源。 不过，到目前为止，我们还没有包括我们的设计资产（Photoshop，Sketch等）。 将您的设计资产置于版本控制之下也是很有意义的。
	https://about.gitlab.com/images/blogimages/getting-started-with-git-lfs-tutorial/project-setup-with-big-files.png

	<h4>但是，这是一个catch：每当我们的设计师对这个新的Photoshop文件做出改变（无论多么小）时，她将向存储库再提交一百MB。 很快，存储库将重达千兆字节和很快的千兆字节，这使得克隆和管理非常繁琐。

	虽然我只是谈到“设计”文件，但这真的是所有“大”文件的问题：电影，录音，数据集等。

<h2>使用LFS：高效的大文件处理 
	当然，LFS不能简单地“消除”所有的大数据：它随着每一个变化而累积，必须被保存。 然而，它将这种负担转移到远程服务器 - 允许本地存储库保持相对精简！

	为了实现这一点，LFS使用一个简单的技巧：它不会将所有文件的版本保留在本地存储库中。 相反，它只提供在检出版本中必要的文件。

	但是这提出了一个有趣的问题：如果这些巨大的文件本身不存在于你的本地存储库...什么是现在？ LFS保存轻量级指针代替真实的文件数据。 当您使用这样的指针检查修订版本时，LFS只需查找原始文件（可能在服务器上，如果它不在自己的特殊缓存中），并为您下载。

	因此，您只能得到您真正想要的文件，而不是您可能永远不需要的一大堆多余的数据。
https://askubuntu.com/questions/236598/best-compression-method/938356#938356

