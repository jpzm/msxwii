/***************************************************************
 *
 * Copyright (C) 2008-2011 Tim Brugman
 *
 * This file may be licensed under the terms of of the
 * GNU General Public License Version 2 (the ``GPL'').
 *
 * Software distributed under the License is distributed
 * on an ``AS IS'' basis, WITHOUT WARRANTY OF ANY KIND, either
 * express or implied. See the GPL for the specific language
 * governing rights and limitations.
 *
 * You should have received a copy of the GPL along with this
 * program. If not, go to http://www.gnu.org/licenses/gpl.html
 * or write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 ***************************************************************/
#ifndef _GUI_ATOM_H
#define _GUI_ATOM_H

class GuiRootContainer;

class GuiAtom
{
public:
    GuiAtom();
    GuiAtom(GuiRootContainer* root);
    virtual ~GuiAtom();

    bool IsAlive(GuiAtom *atom);
    virtual void Delete(GuiAtom *atom);

    static GuiRootContainer* GetRootContainer(void);

protected:
    static void SetRootContainer(GuiRootContainer* root);

private:
    static GuiRootContainer* m_poRootContainer;
};

#endif

