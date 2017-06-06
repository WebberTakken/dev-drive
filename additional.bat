::PoshGit
choco install poshgit --yes -ia "INSTALLDIR=""%InstallDir%poshgit"""
:UpdateGit
choco install poshgit --yes -ia "INSTALLDIR=""%InstallDir%poshgit"""
:AddPathForGitBinaries
Call Userpath Add %InstallDir%poshgit